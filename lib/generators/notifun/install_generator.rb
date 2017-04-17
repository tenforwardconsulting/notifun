require 'rails/generators/migration'
require 'rails/generators/active_record'

class Notifun::InstallGenerator < Rails::Generators::Base
  include Rails::Generators::Migration
  source_root File.expand_path("../templates", __FILE__)

  def copy_notifun_migration
    migration_template "migration.rb", "db/migrate/notifun_create_tables.rb"
  end

  def copy_config_file
    copy_file "notifun.rb", "config/initializers/notifun.rb"
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
