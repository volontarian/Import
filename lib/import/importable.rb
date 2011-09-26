class ActiveRecord::Base
  class << self
    def find_existing_entries(criteria, values)
      class_eval <<-EOV
find_by_sql(
  [
    "SELECT #{self.table_name}.id AS id, #{self.table_name}.name AS name FROM #{self.table_name} WHERE #{criteria}",
    "#{values.join('", "')}"
  ]
).map{|a| [a.id, a.name]}
EOV
    end  
  end
end