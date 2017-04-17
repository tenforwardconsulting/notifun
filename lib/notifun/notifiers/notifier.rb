module Notifun::Notifier
  def self.push_notifier
    "#{Notifun.configuration.push_notifier}_notifier".constantize
  end
end

require 'notifun/notifiers/cloud_five_notifier'
