require 'rails/generators/migration'
require 'rails/generators/active_record'
require_relative '../../../app/models/notifun/message_template'

class Notifun::InstallGenerator < Rails::Generators::Base
  include Rails::Generators::Migration
  source_root File.expand_path("../templates", __FILE__)

  def copy_notifun_migration
    if !ActiveRecord::Base.connection.table_exists?('notifun_message_templates')
      migration_template "migration.rb", "db/migrate/notifun_create_tables.rb"
    else
      puts "Skipping db/migrate/notifun_create_tables.rb"
      Notifun::MessageTemplate.reset_column_information
      if !Notifun::MessageTemplate.column_names.include?("push_title")
        migration_template "notifun_add_push_title.rb", "db/migrate/notifun_add_push_title.rb"
      end
    end
  end

  def copy_config_file
    if File.exists?("config/initializers/notifun.rb")
      puts "Skipping config/initializers/notifun.rb"
    else
      copy_file "notifun.rb", "config/initializers/notifun.rb"
    end
  end

  def copy_json_file
    if File.exists?("config/notifun_templates.json")
      puts "Skipping config/notifun_templates.json"
    else
      copy_file "notifun_templates.json", "config/notifun_templates.json"
    end
  end

  def rails5?
    Rails.version.start_with? '5'
  end

  def migration_version
    if rails5?
      "[#{Rails::VERSION::MAJOR}.#{Rails::VERSION::MINOR}]"
    end
  end

  def self.next_migration_number(dirname)
    ActiveRecord::Generators::Base.next_migration_number(dirname)
  end
end
