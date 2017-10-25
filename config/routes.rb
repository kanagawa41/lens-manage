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
      post 'delete_objects_ajax'
      get 'fetch_tree_datas_ajax'
      get 'reset_tags_ajax'
      get 'reset_word_ranking'
      get 'check_strange_word'
    end
  end

  resources :lens_lists do
    collection do
      get 'index'
      get 'open_info'
      get 'top'
      get 'about'
      get 'contact'
      get 'category'
      get 'tag/:tag' => :tag
    end
  end

end
