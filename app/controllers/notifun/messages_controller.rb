class Notifun::MessagesController < Notifun.configuration.parent_controller.constantize
  def index
    @messages = Notifun::Message.all
  end
end
