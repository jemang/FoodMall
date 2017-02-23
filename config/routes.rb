Rails.application.routes.draw do
  resources :users

  root 'users#index'

  get '/login' => 'sessions#new'
  post '/login' => 'sessions#create'
  get '/logout' => 'sessions#destroy'

  get '/signup' => 'users#new'
  get '/customer_page' => 'users#cust_page'
  match '/customer',   to: 'users#cust_page',   via: 'get'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
