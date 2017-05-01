class Notifun::Preference < ActiveRecord::Base
  self.table_name = 'notifun_preferences'

  belongs_to :preferable, polymorphic: true

  def notification_methods
    array = []
    array << Notifun::NotificationMethods::EMAIL if email
    array << Notifun::NotificationMethods::PUSH if push
    array << Notifun::NotificationMethods::TEXT if text
    array & Notifun.configuration.notification_methods
  end
end
