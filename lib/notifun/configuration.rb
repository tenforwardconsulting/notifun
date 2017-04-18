class Notifun::Configuration
  attr_accessor :notification_methods, :parent_mailer, :push_notifier, :wysiwyg, :parent_controller, :controller_method

  def initialize
    @notification_methods = []
    @parent_mailer = 'ActionMailer::Base'
    @push_notifier = "empty"
    @wysiwyg = "none"
    @parent_controller = "ActionController::Base"
    @controller_method = nil
  end
end
