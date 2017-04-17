class Notifun::Configuration
  attr_accessor :notification_methods, :parent_mailer, :push_notifier, :wysiwyg

  def initialize
    @notification_methods = []
    @parent_mailer = 'ActionMailer::Base'
    @push_notifier = "empty"
    @wysiwyg = "none"
  end
end
