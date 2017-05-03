Notifun.configure do |config|
  # Configure which types of notifications can be sent
  # "email", "push", "text"
  config.notification_methods = ["email"]

  # Configure the parent class responsible to send e-mails.
  config.parent_mailer = 'ApplicationMailer'

  # Configure how to send push notifications
  # "CloudFive", "Empty"
  # config.push_notifier = "CloudFive"
  # config.push_config = { api_key: ENV["CLOUD_FIVE_API_KEY"] }

  # Configure how to send text notifications
  # "Twilio", "Empty"
  # config.text_notifier = "Twilio"
  # config.text_config = { account_sid: ENV["TWILIO_ACCOUNT_SID"], auth_token: ENV["TWILIO_AUTH_TOKEN"], from: "+14159341234" }

  # Configure how to edit html fields
  # "froala", timymce", "none"
  # config.wysiwyg = "timymce"

  # Configure parent class for Notifun controllers for admin actions like editing message templates
  config.admin_parent_controller = 'ApplicationController'

  # Configure parent class for Notifun controllers for user actions like editing preferences
  config.user_parent_controller = 'ApplicationController'

  # Configure controller helper method to use to get the model
  # notifun should use for the currently logged in person for the preferences page
  # should correspond to the 'models' attribute on message template
  # this must be set for preferences to work
  # can return an array of models
  # config.controller_method = "current_user"
end
