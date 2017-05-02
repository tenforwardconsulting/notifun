class Notifun::Notifier::CloudFiveNotifier
  def self.notify!(text, title, uuid, options)
    if !defined?(CloudFivePush)
      return false
    end
    api_key = options[:api_key].presence
    api_key ||= Notifun.configuration.push_config[:api_key]
    return false unless api_key.present?
    notification = CloudFivePush::Notification.new(api_key)
    if title.present?
      notification.alert = title
      notification.message = text
    else
      notification.alert = text
      notification.message = ""
    end
    notification.user_identifiers = [uuid]
    notification.data = options[:push_data]
    notification.notify!
  end
end
