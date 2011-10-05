module Import
  class Resource < ActiveRecord::Base  
    set_table_name 'imports'  
  
    belongs_to :author, :class_name => 'User'
    belongs_to :parent, :polymorphic => true
      
    validates :input, :presence => true
    validates_format_of :email, :with  => /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/, :allow_blank => true
    
    serialize :parameters, Hash
    
    attr_accessible :controller_logger, :input, :email  
    attr_accessor :controller_logger,  :parent_import_id
    
    state_machine :state, :initial => :draft do  
      event :confirm do
        transition :draft => :confirmed
      end
      
      event :process do
        #transition :confirmed => :processed
        transition :draft => :processed, :if => :process_successful?
      end
      
      event :my_fail do
        transition :draft => :failed
      end
      
      event :complete do
        transition :processed => :completed
      end
    end
    
    after_initialize :initialize_variables
    
    def initialize_variables
      @raw_resources, @parsed_resources, @existing_resources_criteria, @existing_resources_criteria_values = [], [], [], []
    end
    
    def add_resource(resource)
      resource = resource.gsub('*', '').strip
      
      return if resource.blank? || @raw_resources.include?(resource)
      
      @raw_resources << resource
      resource = parse_resource(resource.strip)
      @parsed_resources << resource
      
      append_existing_resources_criteria(resource)
      
      resource
    end 
    
    def values
      @raw_resources
    end
    
    def collection(force = true)
      if force
        @existing_collection = find_existing_resources
      else
        @existing_collection ||= find_existing_resources
      end
    end
    
    protected
    
    def parse_resource(resource)
      raise I18n.t('imports.errors.override_parse_resource', :class_name => self.class.name)
    end
    
    def append_existing_resources_criteria(resource)
      raise I18n.t('imports.errors.override_append_existing_resources_criteria', :class_name => self.class.name)
    end
    
    def all_dependencies_loaded?
      true
    end
    
    def import_dependencies
    end
    
    def import_resources  
      raise I18n.t('imports.errors.override_import_resources', :class_name => self.class.name)  
    end
    
    def find_existing_resources
      unless @existing_resources_criteria.empty?
        resource_class.find_existing_entries(
          @existing_resources_criteria.join(' OR '), 
          @existing_resources_criteria_values
        )
      else
        []
      end
    end
    
    def parsed_resources_missing
      raise I18n.t('imports.errors.override_parsed_resources_missing', :class_name => self.class.name)  
    end
      
    def resource_class
      class_name = self.class.name.split('::')
      class_name.shift
      class_name.join('::').constantize
    end
    
    def table_name
      class_name = self.class.name.split('::')
      class_name.shift
      class_name.join('::').tableize.gsub('/', '_')
    end
    
    def log(message)
      controller_logger.debug message unless controller_logger == nil
    end
    
    private
    
    def process_successful?    
      loadInput
      
      raise I18n.t('imports.errors.not_all_dependencies_loaded') unless all_dependencies_loaded?
      
      ActiveRecord::Base.transaction(:requires_new => true) do
        begin      
          import_dependencies_wrapper  
        rescue Exception => my_e
          self.exception = my_e.message + ":" + my_e.backtrace.join('\n')
        end
        
        if self.exception.blank?
          begin
            import_resources_transaction  
          rescue Exception => my_e
            log "import exception:" + my_e.message
            self.exception = my_e.message + ":" + my_e.backtrace.join('\n')
          end
        end
      end
      
      if self.exception.blank?
        return true
      elsif self.parent_import_id.blank?
        raise self.exception
        self.my_fail!
        return false
      else
        raise ActiveRecord::Rollback.new(self.exception)  
        return false
      end
    end
    
    def import_dependencies_wrapper
      begin 
        import_dependencies
      rescue StateMachine::InvalidTransition      
      end
    end
    
    def loadInput 
      unless self.input.blank?
        self.input.split("\r\n").map(&:strip).select{|r| !r.blank? }.each do |resource|
          self.add_resource(resource)
        end
      end
    end
    
    def import_resources_transaction
      begin
        import_resources
      rescue Exception => e
        raise ActiveRecord::Rollback.new("#{e.class.name}: #{e.message} (#{self.class.name}):#{e.backtrace.join('\n')}")
      end
    end
  end
end