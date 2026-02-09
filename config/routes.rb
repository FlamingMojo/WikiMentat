Rails.application.routes.draw do
  ActiveAdmin.routes(self)
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  match '/webhook', to: 'webhooks#create', via: %i[post put get]
  match '/webhooks', to: 'webhooks#create', via: %i[post put get]
  match 'auth/:provider/callback', to: 'sessions#create', via: %i[get post]
  get '/login', to: 'sessions#new'
  get '/logout', to: 'sessions#destroy', as: :destroy_user_session
  root 'homes#index'
end
