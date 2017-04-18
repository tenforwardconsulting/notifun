module Notifun::Notifier
  def self.push_notifier
    "Notifun::Notifier::#{Notifun.configuration.push_notifier}Notifier".constantize
  end
end

require 'notifun/notifiers/cloud_five_notifier'
