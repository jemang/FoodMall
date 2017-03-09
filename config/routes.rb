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
  get '/customer' => 'users#customer'
  get '/admin' => 'users#admin'
  get '/runner' => 'users#runner'
  get '/chef' => 'users#chef'

  post '/edit_multiple' => 'orderitems#edit_multiple'
  put '/update_multiple' => 'orderitems#update_multiple'
  get '/view_orderitem' => 'orderitems#view_orderitem'
  post '/edit_cust_order' => 'orderitems#edit_cust_order'
  put '/update_cust_order' => 'orderitems#update_cust_order'

  put '/update_stask' => 'items#update_stask'
  get '/my_task' => 'items#my_task'
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
