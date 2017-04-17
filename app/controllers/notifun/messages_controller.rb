class Notifun::MessagesController < ApplicationController
  def index
    @messages = Notifun::Message.all
  end
end
