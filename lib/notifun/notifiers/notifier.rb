module Notifun::Notifier
  def self.email_notifier
    "Notifun::Notifier::EmailNotifier".constantize
  end
  def self.push_notifier
    "Notifun::Notifier::#{Notifun.configuration.push_notifier}Notifier".constantize
  end
  def self.text_notifier
    "Notifun::Notifier::#{Notifun.configuration.text_notifier}Notifier".constantize
  end
end

require 'notifun/notifiers/parent_notifier'
require 'notifun/notifiers/email_notifier'
require 'notifun/notifiers/empty_notifier'
require 'notifun/notifiers/cloud_five_notifier'
require 'notifun/notifiers/twilio_notifier'
