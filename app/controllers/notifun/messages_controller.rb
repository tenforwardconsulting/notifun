class Notifun::MessagesController < Notifun.configuration.parent_controller.constantize
  def index
    limit = 10

    @page = (params[:page].presence || 1).to_i
    offset = limit * (@page - 1)
    @messages = Notifun::Message.order(created_at: :desc)
    @pages = (@messages.count / limit.to_f).ceil
    @messages = @messages.limit(limit).offset(offset)
  end
end
