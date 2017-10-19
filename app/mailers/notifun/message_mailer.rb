class Notifun::MessageMailer < Notifun.configuration.parent_mailer.constantize
  def send_message(email, subject, html, text, message_template, options={})
    @notifun_models = message_template.models

    if options[:attachments].present?
      options[:attachments].each do |key, value|
        attachments[key] = value
      end
    end

    if options[:instance_variables].present?
      options[:instance_variables].each do |key, value|
        instance_variable_set("@#{key}", value)
      end
    end

    settings = {
      to: email,
      subject: subject
    }

    if options[:from].present?
      settings[:from] = options[:from]
    end
    if options[:reply_to].present?
      settings[:reply_to] = options[:reply_to]
    end

    if Rails.version[0].to_i > 4
      hack_layout = _layout(["text"])
    else
      hack_layout = _layout
    end

    mail(settings) do |format|
      format.text { render plain: text, layout: hack_layout }
      format.html { render html: html.html_safe, layout: hack_layout }
    end
  end
end
