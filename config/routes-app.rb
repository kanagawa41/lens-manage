###
# App用のルーティング
###
Rails.application.routes.draw do
  root :to => 'lens_lists#top'

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
