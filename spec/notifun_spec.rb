require 'spec_helper'
require 'json'
require_relative '../lib/notifun/notification'
require_relative '../lib/notifun/message_template'

RSpec.describe Notifun do
  let(:caddie_reminder_json) {%|
{
  "caddie_reminder" : {
    "description" : "Reminder that goes out to caddies the night before, the morning of, and 24 hours before a booking.",
    "category" : "booking",
    "default_notification_methods" : ["push", "email"],
    "backup_notification_methods" : [],
    "merge_fields" : {
      "caddie_full_name" : "Name of the caddie",
      "golfer_full_name" : "Full name of the golfer",
      "tee_time" : "The tee time of the booking",
      "tee_date" : "The date of the tee time",
      "tee_date_and_time" : "The date and time of the booking",
      "location" : "Name of the course",
      "confirmation_code" : "Reference code for the caddie"
    },
    "push_body" : "Reminder: You signed up to caddie at {tee_date_and_time} at {location}. Confirmation Code: {confirmation_code}",
    "email_subject" : "You have a booking scheduled for tomorrow.",
    "email_html" : "<h3>Hello, {caddie_full_name},</h3><p>You signed up to caddie for {golfer_full_name} at {location} on <span class='confirmation-date'>{tee_date}</span> at <span class='confirmation-time'>{tee_time}</span></p><p><span class='uppercase'>Confirmation Code:</span><span class='confirmation-code'>{confirmation_code}</span></p>",
    "email_text" : "Hello, {caddie_full_name}, You signed up to caddie for {golfer_full_name} at {location} on {tee_date} at {tee_time} Confirmation Code: {confirmation_code}"
  }
}|
}
  let!(:message_template) {
    hash = JSON.parse(caddie_reminder_json)
    message_template = Notifun::MessageTemplate.where(key: "caddie_reminder").first_or_initialize
    message_template.attributes = hash["caddie_reminder"]
    message_template.save!
    message_template
  }
  let(:caddie) { FactoryGirl.create :caddie }
  it "sends push and email since both are in default_notification_methods" do
    message_template.update(default_notification_methods: ["push", "email"], backup_notification_methods: [])
    expect(CloudFivePush).to receive(:notify!).with("Reminder: You signed up to caddie at Tuesday 10AM at Test Course. Confirmation Code: 123456", caddie.uuid)
    expect(Notifun::MessageMailer).to receive(:send_message).with(caddie.email, "You have a booking scheduled for tomorrow.", "Hello, Test Caddie, You signed up to caddie for Test Golfer at Test Course on Tuesday at 10AM Confirmation Code: 123456", "<h3>Hello, Test Caddie,</h3><p>You signed up to caddie for Test Golfer at Test Course on <span class=\"confirmation-date\">Tuesday</span> at <span class=\"confirmation-time\">10AM</span></p><p><span class=\"uppercase\">Confirmation Code:</span><span class=\"confirmation-code\">123456</span></p>").and_call_original

    Notifun.notify(caddie, :caddie_reminder, {
      caddie_full_name: "Test Caddie",
      golfer_full_name: "Test Golfer",
      tee_date: "Tuesday",
      tee_time: "10AM",
      tee_date_and_time: "Tuesday 10AM",
      location: "Test Course",
      confirmation_code: "123456"
    })

    expect(message_template.reload.messages.count).to eq 2

    message = message_template.messages.first
    expect(message.message_template_key).to eq "caddie_reminder"
    expect(message.uuid).to eq caddie.uuid
    expect(message.recipient).to eq caddie.uuid
    expect(message.notification_method).to eq "push"
    expect(message.message_text).to eq "Reminder: You signed up to caddie at Tuesday 10AM at Test Course. Confirmation Code: 123456"

    message = message_template.messages.last
    expect(message.message_template_key).to eq "caddie_reminder"
    expect(message.uuid).to eq caddie.uuid
    expect(message.recipient).to eq caddie.email
    expect(message.notification_method).to eq "email"
    expect(message.message_text).to eq "<h3>Hello, Test Caddie,</h3><p>You signed up to caddie for Test Golfer at Test Course on <span class=\"confirmation-date\">Tuesday</span> at <span class=\"confirmation-time\">10AM</span></p><p><span class=\"uppercase\">Confirmation Code:</span><span class=\"confirmation-code\">123456</span></p>"
  end

  it "sends just push if email is in backup and push works" do
    message_template.update(default_notification_methods: ["push"], backup_notification_methods: ["email"])

    expect(CloudFivePush).to receive(:notify!)
    expect(Notifun::MessageMailer).to_not receive(:send_message)

    Notifun.notify(caddie, :caddie_reminder, {
      caddie_full_name: "Test Caddie",
      golfer_full_name: "Test Golfer",
      tee_date: "Tuesday",
      tee_time: "10AM",
      tee_date_and_time: "Tuesday 10AM",
      location: "Test Course",
      confirmation_code: "123456"
    })

    expect(message_template.reload.messages.count).to eq 1
  end

  it "sends email if push fails to send" do
    message_template.update(default_notification_methods: ["push"], backup_notification_methods: ["email"])
    caddie.user.update(disable_push_notifications: true)

    expect(CloudFivePush).to_not receive(:notify!)
    expect(Notifun::MessageMailer).to receive(:send_message).and_call_original

    Notifun.notify(caddie, :caddie_reminder, {
      caddie_full_name: "Test Caddie",
      golfer_full_name: "Test Golfer",
      tee_date: "Tuesday",
      tee_time: "10AM",
      tee_date_and_time: "Tuesday 10AM",
      location: "Test Course",
      confirmation_code: "123456"
    })

    expect(message_template.reload.messages.count).to eq 1
  end
end
