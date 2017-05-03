class Notifun::Notifier::ParentNotifier
  attr_accessor :success, :error_message

  def initialize
    @success = false
    @error_message = nil
  end

  def notify!(*arguments)
    false
  end
end
