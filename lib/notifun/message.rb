class Notifun::Message < ActiveRecord::Base
  self.table_name = 'notifun_messages'

  def message_template
    Notifun::MessageTemplate.where(key: message_template_key).first
  end
end
