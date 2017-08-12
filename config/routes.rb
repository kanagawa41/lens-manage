Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  root :to => 'lens_lists#top'

  resources :lens_lists do
    collection do
      get 'index'
      get 'top'
    end
  end

end
