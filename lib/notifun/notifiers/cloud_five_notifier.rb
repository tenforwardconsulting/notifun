class Notifun::Notifier::CloudFiveNotifier
  def self.notify!(text, uuid)
    CloudFivePush.notify!(text, uuid)

    true
  end
end
