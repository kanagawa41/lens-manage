Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :m_shop_infos, :controller => 'm_shop_infos'
  resources :collect_targets, :controller => 'collect_targets'
  
  get '/top', to: 'lens_lists#index'
end
