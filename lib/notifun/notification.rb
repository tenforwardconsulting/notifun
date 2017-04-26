class Notifun::Notification
  # model passed in must have following methods:
  # notifun_uuid or uuid: unique identifier
  # notifun_email or email: email to send to
  # notifun_notify_via or notify_via(method) returns if it should send message using one of the message types: ["email", "push"]
  def self.notify(models, key, merge_hash={}, options={})
    message_template = Notifun::MessageTemplate.find_by_key(key)
    raise "Unable to find message_template with key #{key}" if message_template.nil?
    models = [models].flatten
    status = true
    models.each do |model|
      primary_sent = false
      backup_sent = false
      preference = Notifun::Preference.where(preferable: model).where(message_template_key: key).first
      if message_template.category.present?
        preference ||= Notifun::Preference.where(preferable: model).where(category: message_template.category).first
      end
      if preference
        sent = false
        preference.notification_methods.each do |notification_method|
          next if options[:notification_methods] && !options[:notification_methods].include?(notification_method)
          sent = self.send("send_via_#{notification_method}", message_template, model, merge_hash, options)
        end

        return sent
      else
        message_template.default_notification_methods.each do |notification_method|
          next if options[:notification_methods] && !options[:notification_methods].include?(notification_method)
          notify_via = model.try(:notifun_notify_via, notification_method)
          notify_via = model.notify_via(notification_method) if notify_via.nil?
          if notify_via
            if self.send("send_via_#{notification_method}", message_template, model, merge_hash, options)
              primary_sent = true
            end
          end
        end
        if !primary_sent
          message_template.backup_notification_methods.each do |notification_method|
            next if options[:notification_methods] && !options[:notification_methods].include?(notification_method)
            notify_via = model.try(:notifun_notify_via, notification_method)
            notify_via = model.notify_via(notification_method) if notify_via.nil?
            if notify_via
              if self.send("send_via_#{notification_method}", message_template, model, merge_hash, options)
                backup_sent = true
                break
              end
            end
          end
        end

        if status == true
          status = primary_sent || backup_sent
        end
      end
    end

    return status
  end

  def self.send_via_text(message_template, model, merge_hash, options)
    if options[:message]
      text = options[:message]
    else
      text = message_template.merged_text_body(merge_hash)
    end
    phone = model.try(:notifun_phone).presence || model.try(:phone).presence
    success = false
    if phone
      success = Notifun::Notifier.text_notifier.notify!(text, phone, options)
    end
    uuid = model.try(:notifun_uuid).presence || model.try(:uuid).presence

    Notifun::Message.create({
      message_template_key: message_template.key,
      uuid: uuid,
      recipient: phone,
      notification_method: "text",
      message_text: text,
      success: success
    })

    return success
  end

  def self.send_via_push(message_template, model, merge_hash, options)
    if options[:message]
      text = options[:message]
    else
      text = message_template.merged_push_body(merge_hash)
    end
    uuid = model.try(:notifun_uuid).presence || model.try(:uuid).presence
    success = false
    if uuid
      success = Notifun::Notifier.push_notifier.notify!(text, uuid, options)
    end
    Notifun::Message.create({
      message_template_key: message_template.key,
      uuid: uuid,
      recipient: uuid,
      notification_method: "push",
      message_text: text,
      success: success
    })

    return success
  end

  def self.send_via_email(message_template, model, merge_hash, options)
    success = false
    if options[:subject]
      subject = options[:subject]
    else
      subject = message_template.merged_email_subject(merge_hash)
    end
    if options[:message]
      text = html = options[:message]
    else
      text = message_template.merged_email_text(merge_hash)
      html = message_template.merged_email_html(merge_hash)
    end
    email = model.try(:notifun_email).presence || model.try(:email).presence
    if email
      Notifun::MessageMailer.send_message(email, subject, html, text, message_template, options).deliver_later
      success = true
    end

    uuid = model.try(:notifun_uuid).presence || model.try(:uuid).presence

    Notifun::Message.create({
      message_template_key: message_template.key,
      uuid: uuid,
      recipient: email,
      notification_method: "email",
      message_text: html,
      success: success
    })

    return success
  end
end
