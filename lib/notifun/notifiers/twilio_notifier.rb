class Notifun::Notifier::TwilioNotifier < Notifun::Notifier::ParentNotifier
  def notify!(text, phone, options)
    if !defined?(Twilio)
      @success = false
      @error_message = "Twilio is not defined."
      return
    end

    account_sid = Notifun.configuration.text_config[:account_sid]
    auth_token = Notifun.configuration.text_config[:auth_token]
    from = Notifun.configuration.text_config[:from]
    return false unless account_sid.present? && auth_token.present? && from.present?

    begin
      client = Twilio::REST::Client.new account_sid, auth_token
      client.messages.create(
        from: from,
        to: phone,
        body: text
      )
    rescue Twilio::REST::RequestError => e
      @success = false
      @error_message = e.message
    end

    @success = true
  end
end
