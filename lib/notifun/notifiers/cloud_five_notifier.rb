class Notifun::Notifier::CloudFiveNotifier
  def self.notify!(text, uuid, options)
    if !defined?(CloudFivePush)
      return false
    end
    api_key = Notifun.configuration.push_config[:api_key]
    return false unless api_key.present?
    notification = CloudFivePush::Notification.new(api_key)
    notification.alert = text
    notification.message = text
    notification.user_identifiers = [uuid]
    push_data = options[:push_data]
    notification.data = push_data
    notification.notify!

    true
  end
end
