class Notifun::Notifier::CloudFiveNotifier
  def self.notify!(text, uuid, options)
    notification = CloudFivePush::Notification.new
    notification.alert = text
    notification.message = text
    notification.user_identifiers = [uuid]
    push_data = options[:push_data]
    notification.data = push_data
    notification.notify!

    true
  end
end
