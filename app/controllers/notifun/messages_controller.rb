class Notifun::MessagesController < Notifun.configuration.admin_parent_controller.constantize
  def index
    limit = 100

    @page = (params[:page].presence || 1).to_i
    offset = limit * (@page - 1)
    @messages = Notifun::Message.order(created_at: :desc)
    @pages = (@messages.count / limit.to_f).ceil
    @messages = @messages.limit(limit).offset(offset)
  end

  def show
    @message = Notifun::Message.find(params[:id])
  end
end
