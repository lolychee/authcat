# frozen_string_literal: true

Rails.application.routes.draw do
  root to: "home#index"

  scope :sign_in, as: :sign_in do
    scope "(:auth_method)" do
      get  :/, to: "user_sessions#new"
      post :/, to: "user_sessions#create"

      # omniauth callback
      match :callback, to: "user_sessions#create", via: %i[get post]
    end
  end
  post :sign_out, to: "user_sessions#destroy", as: :sign_out

  scope :sign_up, as: :sign_up do
    get  :/,  to: "users#new"
    post :/,  to: "users#create"
  end

  resources :users

  namespace :settings do
    root to: "profiles#show"
    resource :profile, only: %i[show update]
    resource :account, only: %i[show update]
    resource :password, only: %i[show update]
    resource :security, only: %i[show update]
    resource :one_time_password, only: %i[show update]
    resource :recovery_codes, only: %i[show update]
    resources :passkeys
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
