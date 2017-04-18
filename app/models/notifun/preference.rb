class Notifun::Preference < ActiveRecord::Base
  self.table_name = 'notifun_preferences'

  belongs_to :preferable, polymorphic: true

  def notification_methods
    array = []
    array << "email" if email
    array << "push" if push
    array << "text" if text
    array & Notifun.configuration.notification_methods
  end
end
