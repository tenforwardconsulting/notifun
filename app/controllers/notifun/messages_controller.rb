class Notifun::MessagesController < Notifun.configuration.parent_controller.constantize
  def index
    @messages = Notifun::Message.order(created_at: :desc)
  end
end
