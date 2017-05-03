class Notifun::Notifier::CloudFiveNotifier < Notifun::Notifier::ParentNotifier
  def notify!(text, title, uuid, options)
    if !defined?(CloudFivePush)
      @success = false
      @error_message = "CloudFivePush is not defined."
      return
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
    response = notification.notify!

    if response['success']
      @success = true
    else
      @error_message = response["error"].presence || "Failed to send push notification"
      @success = false
    end
  end
end
