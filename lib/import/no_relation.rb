module Import
  class NoRelation < Resource
    protected
    
    def parse_resource(resource)
      resource.gsub('*', '').strip
    end
    
    def append_existing_resources_criteria(resource)
      @existing_resources_criteria << "(#{table_name}.name = ?)"
      @existing_resources_criteria_values << resource
    end
    
    def import_resources   
      log "#{parsed_resources_missing.length} of #{@parsed_resources.length} new #{resource_class.name.humanize.pluralize}."  
      
      new_resources_data = []
      
      parsed_resources_missing.each do |resource|            
        new_resources_data << new_record(resource)
      end
      
      log "Creating #{new_resources_data.length} new #{resource_class.name.humanize.pluralize}."
      
      unless new_resources_data.empty?
        resource_class.import(columns, new_resources_data, :validate => false)
      end 
    end
    
    def parsed_resources_missing
      @parsed_resources_missing ||= @parsed_resources.select{|r| !collection(false).map(&:second).include?(r) }  
    end
    
    def new_record(resource)
      [resource]
    end
    
    def columns
      [:name]
    end
  end
end