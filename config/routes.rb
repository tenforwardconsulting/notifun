# notifun/config/routes.rb
Rails.application.routes.draw do
  namespace :notifun do
    resources :message_templates do
      member do
        get :preview
      end
    end
    resources :messages, only: [:index]
  end
end
