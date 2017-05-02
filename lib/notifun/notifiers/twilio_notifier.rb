class Notifun::Notifier::TwilioNotifier
  def self.notify!(text, phone, options)
    if !defined?(Twilio)
      return false
    end

    account_sid = Notifun.configuration.text_config[:account_sid]
    auth_token = Notifun.configuration.text_config[:auth_token]
    from = Notifun.configuration.text_config[:from]
    return false unless account_sid.present? && auth_token.present? && from.present?

    client = Twilio::REST::Client.new account_sid, auth_token
    client.messages.create(
      from: from,
      to: phone,
      body: text
    )

    true
  end
end
