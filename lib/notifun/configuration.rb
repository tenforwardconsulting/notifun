class Notifun::Configuration
  attr_accessor :notification_methods, :parent_mailer, :push_notifier, :push_config, :text_notifier, :text_config, :wysiwyg, :parent_controller, :controller_method

  def initialize
    @notification_methods = []
    @parent_mailer = 'ActionMailer::Base'
    @push_notifier = "Empty"
    @push_config = {}
    @text_notifier = "Empty"
    @text_config = {}
    @wysiwyg = "none"
    @parent_controller = "ActionController::Base"
    @controller_method = nil
  end
end
