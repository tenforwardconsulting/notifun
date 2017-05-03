class Notifun::Notifier::EmailNotifier < Notifun::Notifier::ParentNotifier
  def notify!(email, subject, html, text, message_template, options)
    begin
      Notifun::MessageMailer.send_message(email, subject, html, text, message_template, options).deliver_now
      @success = true
    rescue Net::SMTPSyntaxError => e
      @error_message = e.message
      @success = false
    end
  end
end
