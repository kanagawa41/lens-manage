###
# Manage用のルーティング
###
Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  root :to => 'admin/dashboard#index'

  resources :admin do
    collection do
      get 'conoha_list'
    end
  end

  resources :lens_lists do
    collection do
      get 'index'
      get 'open_info'
      get 'top'
      get 'about'
      get 'contact'
    end
  end

end
