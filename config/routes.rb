Rails.application.routes.draw do
  mount ActionCable.server => "/cable"
  devise_for :users


  root to: "users#dashboard"
  
  resources :users, only: [:show] do
    get :dashboard, on: :collection
    get :find_friends, on: :collection, as: :find_friends
  end
  
  resources :friends, only: [:index, :create, :destroy, :update] do
    collection { get :requests }
  end
  resources :groups, only: [:index, :show, :create, :new]
  resources :friendships, only: [:update, :destroy]
  get "chats/:chat_id/messages", to: "messages#show", as: :chat_messages
  post "chats/:chat_id/messages", to: "messages#create"
    
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
