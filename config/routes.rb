Rails.application.routes.draw do
  resources :orderitems 
  resources :items
  resources :users

  root 'users#index'

  get '/login' => 'sessions#new'
  post '/login' => 'sessions#create'
  get '/logout' => 'sessions#destroy'
  get 'pages/home'

  get '/signup' => 'users#new'

  get '/customer' => 'items#customer'
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
