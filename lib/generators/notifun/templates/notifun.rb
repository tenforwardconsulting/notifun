Notifun.configure do |config|
  # Configure which types of notifications can be sent
  config.notification_methods = ["email"]

  # Configure the parent class responsible to send e-mails.
  # config.parent_mailer = 'ApplicationMailer'

  # Configure how to send push notifications
  # "CloudFive", "Empty"
  # config.push_notifier = "CloudFive"

  # Configure how to edit html fields
  # "froala", timymce", "none"
  # config.wysiwyg = "timymce"

  # Configure parent class for Notifun controllers
  # config.parent_controller = 'ApplicationController'

  # Configure controller helper method to use to get the model
  # notifun should use for the currently logged in person for the preferences page
  # should correspond to the 'models' attribute on message template
  # this must be set for preferences to work
  # can return an array of models
  # config.controller_method = "notifun_model"
end
