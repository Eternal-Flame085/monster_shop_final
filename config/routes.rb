Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get :root, to: 'welcome#index'

  #Changed recources to a handroll and handrolls to recources
  # resources :merchants do
  #   resources :items, only: [:index]
  # end
  get '/merchants', to: 'merchants#index'
  get '/merchants/new', to: 'merchants#new'
  post '/merchants', to: 'merchants#create'
  get '/merchants/:id', to: 'merchants#show'
  get '/merchants/:id/edit', to: 'merchants#edit'
  patch '/merchants/:id', to: 'merchants#update'
  delete '/merchants/:id', to: 'merchants#destroy'
  get '/merchants/:merchant_id/items', to: 'items#index'

  # resources :items, only: [:index, :show] do
  #   resources :reviews, only: [:new, :create]
  # end
  get '/items', to: 'items#index'
  get '/items/:id', to: 'items#show'
  post '/items/:id/reviews', to: 'reviews#create'
  get '/items/:item_id/reviews/new', to: 'reviews#new'

  #resources :reviews, only: [:edit, :update, :destroy]
  get '/reviews/:id/edit', to: 'reviews#edit'
  patch '/reviews/:id', to: 'reviews#update'
  delete '/reviews/:id', to: 'reviews#destroy'

  get '/cart', to: 'cart#show'
  post '/cart/:item_id', to: 'cart#add_item'
  delete '/cart', to: 'cart#empty'
  patch '/cart/:change/:item_id', to: 'cart#update_quantity'
  delete '/cart/:item_id', to: 'cart#remove_item'

  get '/registration', to: 'users#new', as: :registration
  #resources :users, only: [:create, :update]
  post '/users', to: 'users#create'
  patch '/users/:id', to: 'users#update'
  #-------------------------------------
  patch '/user/:id', to: 'users#update'
  get '/profile', to: 'users#show'
  get '/profile/edit', to: 'users#edit'
  get '/profile/edit_password', to: 'users#edit_password'
  post '/orders', to: 'user/orders#create'
  get '/profile/orders', to: 'user/orders#index'
  get '/profile/orders/:id', to: 'user/orders#show'
  delete '/profile/orders/:id', to: 'user/orders#cancel'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#login'
  get '/logout', to: 'sessions#logout'

  namespace :merchant do
    get '/', to: 'dashboard#index', as: :dashboard
    #resources :orders, only: :show
    get '/orders/:id', to: 'orders#show'
    #resources :items, only: [:index, :new, :create, :edit, :update, :destroy]
    get '/items', to: 'items#index'
    get '/items/new', to: 'items#new'
    post '/items', to: 'items#create'
    get '/items/:id/edit', to: 'items#edit'
    patch '/items/:id', to: 'items#update'
    delete '/items/:id', to: 'items#destroy'
    put '/items/:id/change_status', to: 'items#change_status'
    get '/orders/:id/fulfill/:order_item_id', to: 'orders#fulfill'
    resources :discounts, exept: [:index, :show]
  end

  namespace :admin do
    get '/', to: 'dashboard#index', as: :dashboard
    #resources :merchants, only: [:show, :update]
    get '/merchants/:id', to: 'merchants#show'
    patch '/merchants/:id', to: 'merchants#update'
    #resources :users, only: [:index, :show]
    get '/users', to: 'users#index'
    get '/users/:id', to: 'users#show'
    patch '/orders/:id/ship', to: 'orders#ship'
  end
end
