require 'rails/generators'
require 'rails/generators/migration'

module Import
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include Rails::Generators::Migration
    
      def self.source_root
        File.join(File.dirname(__FILE__), 'templates')
      end
    
       # Implement the required interface for Rails::Generators::Migration.
       # taken from http://github.com/rails/rails/blob/master/activerecord/lib/generators/active_record.rb
      def self.next_migration_number(dirname) #:nodoc:
        if ActiveRecord::Base.timestamped_migrations
          Time.now.utc.strftime("%Y%m%d%H%M%S")
        else
          "%.3d" % (current_migration_number(dirname) + 1)
        end
      end
      
      def create_migrations
        Dir["#{self.class.source_root}/migrations/*.rb"].sort.each do |filepath|
          name = File.basename(filepath)
          migration_template "migrations/#{name}", "db/migrate/#{name.gsub(/^\d+_/,'')}"
          sleep 1
        end
      end
    end
  end
end