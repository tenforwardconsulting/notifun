require 'notifun/version'
require 'notifun/configuration'
require 'notifun/engine'
require 'notifun/notifiers/notifier'
require 'notifun/notification'

module Notifun
  require 'notifun/railtie' if defined?(Rails)

  class << self
    attr_accessor :configuration
  end

  module NotificationMethods
    EMAIL = 'email'
    PUSH = 'push'
    TEXT = 'text'
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end
end
