require 'notifun/version'
require 'notifun/configuration'
require 'notifun/engine'
require 'notifun/notification'
require 'notifun/message'
require 'notifun/message_template'
require 'notifun/notifiers/notifier'

module Notifun
  require 'notifun/railtie' if defined?(Rails)

  class << self
    attr_accessor :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end
end
