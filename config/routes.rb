# notifun/config/routes.rb
Rails.application.routes.draw do
  namespace :notifun do
    resources :message_templates, param: :key do
      member do
        get :preview
      end
    end
    resources :messages, only: [:index, :show]
    resources :preferences, only: [:index] do
      collection do
        post :save
      end
    end
  end
end
