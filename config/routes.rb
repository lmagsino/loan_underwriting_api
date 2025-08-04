# config/routes.rb
Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      # Authentication routes
      post '/auth/register', to: 'auth#register'
      post '/auth/login', to: 'auth#login'
      get '/auth/profile', to: 'auth#profile'
      
      # Future routes
      resources :loan_applications, only: [:index, :show, :create, :update]
      resources :users, only: [:show, :update]
    end
  end
  
  # Health check
  get '/health', to: proc { [200, {}, ['OK']] }
end