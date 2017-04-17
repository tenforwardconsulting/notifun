class Notifun::Notification
  require 'notifun/railtie' if defined?(Rails)
  # model passed in must have following methods:
  # uuid: unique identifier
  # notifun_email: email to send to
  # notify_via(method) returns if it should send message using one of the message types: ["email", "push"]
  def self.notify(model, key, merge_hash)
    message_template = Notifun::MessageTemplate.find_by_key(key)
    primary_sent = false
    backup_sent = false
    message_template.default_notification_methods.each do |notification_method|
      if model.notify_via(notification_method)
        if self.send("send_via_#{notification_method}", message_template, model, merge_hash)
          primary_sent = true
        end
      end
    end
    if !primary_sent
      message_template.backup_notification_methods.each do |notification_method|
        if model.notify_via(notification_method)
          if self.send("send_via_#{notification_method}", message_template, model, merge_hash)
            backup_sent = true
            break
          end
        end
      end
    end

    return primary_sent || backup_sent
  end

  def self.send_via_push(message_template, model, merge_hash)
    text = message_template.merged_push_body(merge_hash)
    success = Notifun::Notifier.push_notifier.notify!(text, model.uuid)
    Notifun::Message.create({
      message_template_key: message_template.key,
      uuid: model.uuid,
      recipient: model.uuid,
      notification_method: "push",
      message_text: text,
      success: success
    })

    return success
  end

  def self.send_via_email(message_template, model, merge_hash)
    text = message_template.merged_email_text(merge_hash)
    html = message_template.merged_email_html(merge_hash)
    subject = message_template.merged_email_subject(merge_hash)
    success = false
    if email = model.email.presence
      Notifun::MessageMailer.send_message(email, subject, text, html).deliver_later
      success = true
    end

    Notifun::Message.create({
      message_template_key: message_template.key,
      uuid: model.uuid,
      recipient: email,
      notification_method: "email",
      message_text: html,
      success: success
    })

    return success
  end
end
