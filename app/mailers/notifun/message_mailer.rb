class Notifun::MessageMailer < Notifun.configuration.parent_mailer.constantize
  def send_message(email, subject, text, html, options={})
    if options.attachments
      options.attachments.each do |key, value|
        attachments[key] = value
      end
    end

    mail(
      to: email,
      subject: subject
    ) do |format|
      format.text { render plain: text, layout: _layout }
      format.html { render html: html.html_safe, layout: _layout }
    end
  end
end
