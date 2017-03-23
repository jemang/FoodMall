Rails.application.routes.draw do
  
  require 'sidekiq/web'
  mount Sidekiq::Web => '/cron_sidekiq'
  
  resources :templates
  resources :setdefaults
  resources :orderitems 
  resources :items
  resources :users

  root 'users#index'

  get '/login' => 'sessions#new'
  post '/login' => 'sessions#create'
  get '/logout' => 'sessions#destroy'

  get '/signup' => 'users#new'
  get '/customer' => 'users#customer'
  get '/admin' => 'users#admin'
  get '/runner' => 'users#runner'
  get '/chef' => 'users#chef'
  get '/all_user' => 'users#all_user'
  get '/change_password' => 'users#change_password'
  put '/update_password' => 'users#update_password'

  post '/edit_multiple' => 'orderitems#edit_multiple'
  put '/update_multiple' => 'orderitems#update_multiple'
  get '/view_orderitem' => 'orderitems#view_orderitem'
  post '/edit_cust_order' => 'orderitems#edit_cust_order'
  put '/update_cust_order' => 'orderitems#update_cust_order'
  get '/selected_user' => 'orderitems#selected_user'
  get '/admin_order' => 'orderitems#admin_order'

  put '/update_stask' => 'items#update_stask'
  get '/my_task' => 'items#my_task'
  get '/cust_order' => 'items#cust_order'

  get '/template' => 'templates#template'
  get '/cron_job' => 'templates#cron_job'
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
