class Notifun::Configuration
  attr_accessor :notification_methods, :parent_mailer, :push_notifier, :push_config, :text_notifier, :text_config, :wysiwyg, :admin_parent_controller, :user_parent_controller, :controller_method, :time_zone

  def initialize
    @notification_methods = []
    @parent_mailer = 'ActionMailer::Base'
    @push_notifier = "Empty"
    @push_config = {}
    @text_notifier = "Empty"
    @text_config = {}
    @wysiwyg = "none"
    @admin_parent_controller = "ActionController::Base"
    @user_parent_controller = "ActionController::Base"
    @controller_method = "current_user"
    @time_zone = "Etc/UTC"
  end
end
