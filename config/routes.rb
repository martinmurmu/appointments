Appointments::Application.routes.draw do

  get "join/index"

  devise_for :users

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  root :to => 'home#index'

  # Join to waitlist
  post '/:token/join-waitlist' => 'waitlist#index'
  get '/join' => 'join#index'
  get '/waitlist' => 'waitlist#index'
  get '/waitlist/:token' => 'waitlist#show'
  post '/waitlist/:token/consumers' => 'waitlist#new_consumer'
  
  # lgoin and waitlist
  get '/login' , to: redirect('/users/sign_in')
  
  devise_for :manager, :class_name => "User", :controllers => {
    :registrations => "manager/registrations"
  }

  namespace :manager do
    root :to => 'home#index'
    get 'profile' => 'profiles#edit'
    put 'profile' => 'profiles#update'
    post 'home/appointments' => 'home#appointments'
    post 'home/consumer' => 'home#consumer'
    resources :appointments do
      member do
        get 'new' => 'appointments#new'
        get 'consumers'
        put 'rebroadcast' => 'appointments#rebroadcast'
        put 'enable' => 'appointments#enable'
      end
      resources :consumers
    end

    resources :consumers do
      member do
        get 'tags'
        put 'enable' => 'consumers#enable'
      end
      resources :tags
    end
    
    # Static Pages
    get 'faq' => 'pages#faq', as: :faq_page
  end

  # Consumer's messages will go to this route.
  post 'sms' => 'receiver#parse'
  
  get '/:token', to: redirect('/users/sign_in') 
end
