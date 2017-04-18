class Notifun::MessageTemplatesController < Notifun.configuration.parent_controller.constantize
  def index
    @message_templates = Notifun::MessageTemplate.all
  end

  def edit
    @message_template = Notifun::MessageTemplate.find(params[:id])
  end

  def update
    @message_template = Notifun::MessageTemplate.find(params[:id])
    if @message_template.update(message_template_attributes)
      redirect_to edit_notifun_message_template_path(@message_template), notice: "Message Template updated."
    else
      render :edit
    end
  end

  def preview
    @message_template = Notifun::MessageTemplate.find(params[:id])

    render html: @message_template.preview_email_html.html_safe, layout: "mailer"
  end

  private

  def message_template_attributes
    params.require(:notifun_message_template).permit(:push_body, :email_subject, :email_html, :email_text)
  end
end
