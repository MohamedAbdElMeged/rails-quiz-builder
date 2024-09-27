# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  namespace :api do
    namespace :v1 do
      post '/users/sign_up', to: 'users#sign_up'
      post '/users/sign_in', to: 'users#sign_in'
      get '/users/profile', to: 'users#profile'
      resources :quizzes, only: [:index]
    end
  end
end
