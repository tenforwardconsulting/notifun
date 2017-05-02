require_relative '../../app/models/notifun/message_template'
require 'rails'

class Notifun::Railtie < ::Rails::Railtie
  railtie_name :notifun

  console do
    ActiveRecord::Base.connection
  end

  initializer "notifun.load_templates" do |config|
    if ( File.basename($0) != 'rake' && !defined?(::Rake) )
      if !ActiveRecord::Base.connection.table_exists?('notifun_message_templates')
        puts "Notifun not importing templates because Notifun tables don't exist."
      else
        if File.exists?('config/notifun_templates.json')
          begin
            template_json = JSON.parse(File.read("config/notifun_templates.json"))
          rescue
            puts "Notifun template json file is not valid json."
          end

          if template_json
            template_json.each do |key, attributes|
              begin
                message_template = Notifun::MessageTemplate.where(key: key).first_or_initialize
                message_template.attributes = attributes.slice("description", "category", "default_notification_methods", "backup_notification_methods", "merge_fields", "models", "editable", "preferences")
                message_template.push_title ||= attributes["push_title"]
                message_template.push_body ||= attributes["push_body"]
                message_template.email_subject ||= attributes["email_subject"]
                message_template.email_html ||= attributes["email_html"]
                message_template.email_text ||= attributes["email_text"]

                message_template.save!
              rescue StandardError => e
                puts "Failed to load message_template #{key}: #{e.message}"
              end
            end
          end
        else
          puts "No Notifun message templates loaded because app/config/notifun_templates.json does not exist."
        end
      end
    end
  end
end
