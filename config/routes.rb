# config/routes.rb
Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      # Authentication routes
      post '/auth/register', to: 'auth#register'
      post '/auth/login', to: 'auth#login'
      get '/auth/profile', to: 'auth#profile'
      
      # Loan Applications
      resources :loan_applications do
        member do
          post :submit
        end
        
        # Nested documents
        resources :documents, only: [:index, :show, :create, :destroy]
      end
      
      # Users
      resources :users, only: [:show, :update]
    end
  end
  
  # Health check
  get '/health', to: proc { [200, {}, ['OK']] }
end