Rails.application.routes.draw do
  devise_for :users
  root 'home#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      resources :users
      resources :registrations, only: [:create] 
      resources :sessions, only: [:create, :destroy]
      post '/users/disable_otp_validate_auth'
      post '/users/enable_otp_validate_auth'
      post '/users/validate_otp'
      get '/users/me' => 'users#me'
      
      post '/users/disable_otp_validate_auth'
      post '/users/enable_otp_validate_auth'
      post '/users/otp_enabled'
    end

  end
end
