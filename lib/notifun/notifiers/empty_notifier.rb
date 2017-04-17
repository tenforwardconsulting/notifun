class Notifun::Notifier::EmptyNotifier
  def self.notify!(*arguments)
    false
  end
end
