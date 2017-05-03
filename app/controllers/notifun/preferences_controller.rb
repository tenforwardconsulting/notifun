class Notifun::PreferencesController < Notifun.configuration.user_parent_controller.constantize
  def index
    begin
      @models = self.send(Notifun.configuration.controller_method)
    rescue
      render text: "Notifun.configuration.controller_method is not set or not defined." and return
    end
    @models = [@models].flatten.compact
    if @models.empty?
      render text: "#{Notifun.configuration.controller_method} returned no models."
    end

    @notification_methods = Notifun.configuration.notification_methods.sort
  end

  def save
    params[:preferences].each do |index, preference_params|
      permitted_params = preference_params.slice(:preferable_type, :preferable_id, :category, :message_template_key, :email, :push, :text).permit!
      preference = Notifun::Preference.where(permitted_params.slice(:preferable_type, :preferable_id, preference_params[:preference_type])).first_or_initialize
      preference.attributes = permitted_params
      preference.save!
    end

    redirect_to notifun_preferences_path, notice: "Notification preferences saved."
  end
end
