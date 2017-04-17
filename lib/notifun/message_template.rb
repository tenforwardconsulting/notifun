class Notifun::MessageTemplate < ActiveRecord::Base
  self.table_name = 'notifun_message_templates'

  before_save :ensure_valid_html

  [:push_body, :email_html, :email_text, :email_subject].each do |method|
    define_method("merged_#{method}") do |merge_hash|
      merge(self.send(method), merge_hash)
    end

    define_method("preview_#{method}") do
      merge(self.send(method), merge_fields_preview)
    end
  end

  def messages
    Notifun::Message.where(message_template_key: key)
  end

  def default_notification_methods
    notification_methods = self[:default_notification_methods] & Notifun.configuration.notification_methods
    if notification_methods.empty?
      notification_methods = self[:backup_notification_methods] & Notifun.configuration.notification_methods
    end

    notification_methods
  end

  def backup_notification_methods
    (self[:backup_notification_methods] & Notifun.configuration.notification_methods) - default_notification_methods
  end

  def notification_methods
    default_notification_methods + backup_notification_methods
  end

  def push?
    notification_methods.include?("push")
  end

  def email?
    notification_methods.include?("email")
  end

  def sent_via
    text = default_notification_methods.join(' and ')
    if backup_notification_methods.any?
      text += " or "
      text += backup_notification_methods.join(', ')
    end

    text
  end

  def merge_fields_preview
    merge_fields.reduce({}){|hash, (k,v)| hash[k] = v["preview"].presence || v["description"] || v; hash}
  end

  def merge_fields_description
    merge_fields.reduce({}){|hash, (k,v)| hash[k] = v["description"] || v; hash}
  end

  def merge_fields_display
    text = []
    merge_fields_description.each do |key, description|
      text << "{#{key}} => #{description}"
    end
    text.join('<br>').html_safe
  end

  private

  def merge(text, merge_hash)
    merge_hash.each do |key, value|
      text.gsub!(/\{#{key}\}/, value)
    end

    text
  end

  def ensure_valid_html
    self.email_html = Nokogiri::HTML::DocumentFragment.parse(email_html).to_html
  end
end
