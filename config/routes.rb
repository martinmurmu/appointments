Appointments::Application.routes.draw do
  scope 'peachtree-health' do
    get "join/index"
  
    devise_for :users
  
    devise_for :admin_users, ActiveAdmin::Devise.config
    ActiveAdmin.routes(self)
  
    root :to => 'home#index'
  
    # Join to waitlist
    get '/:token/join-waitlist' => 'waitlist#index', :as => 'join_waitlist'
    get '/join-waitlist' => 'waitlist#index', :as => 'join_waitlist'
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
      get 'home/countwaitlist' => 'home#countwaitlist'
      get 'home/countappointment' => 'home#countappointment'
      post 'home/appointments' => 'home#appointments'
      post 'home/consumer' => 'home#consumer'
      resources :appointments do
        member do
          get 'new' => 'appointments#new'
          get 'consumers'
          put 'rebroadcast' => 'appointments#rebroadcast'
          put 'filled' => 'appointments#filled'
          put 'canceled' => 'appointments#canceled'
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
      
      resources :managers do
        member do
          get '/' => 'managers#index'
          get 'new' => 'managers#new'
          get 'edit' => 'managers#edit'
          post 'create' => 'managers#create'
          post 'update' => 'managers#update'
          delete 'destroy' => 'managers#destroy', as: 'destroy'
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
end
