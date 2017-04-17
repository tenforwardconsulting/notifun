Notifun.configure do |config|
  # Configure which types of notifications can be sent
  config.notification_methods = ["email"]

  # Configure the parent class responsible to send e-mails.
  # config.parent_mailer = 'ActionMailer::Base'

  # Configure how to send push notifications
  # "CloudFive", "Empty"
  # config.push_notifier = "CloudFive"

  # Configure how to edit html fields
  # "timymce", "none"
  # config.wysiwyg = "timymce"
end
