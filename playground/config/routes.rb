# frozen_string_literal: true

Rails.application.routes.draw do
  root to: "home#index"

  # resource :session, only: %i[show create destroy]
  # get  :sign_in,  to: "sessions#new", as: :sign_in
  # post :sign_in,  to: "sessions#create"
  post :sign_out, to: "sessions#destroy", as: :sign_out
  # match "/auth/:provider/callback", to: "sessions#omniauth", via: %i[get post]

  scope :sign_in do
    scope "(:identifier)", as: :sign_in do
      get  :/, to: "sessions#new"
      post :/, to: "sessions#create"
    end
    scope "challenge/:factor", as: :sign_in_challenge do
      get  :/, to: "sessions/challenge#new"
      post :/, to: "sessions/challenge#create"
    end

    scope "idp/:provider", as: :sign_in_idp do
      post :/, to: "sessions/idp#new"
      get :setup, to: "sessions/idp#setup"
      match :callback, to: "sessions/idp#callback", via: %i[get post]
    end
  end

  resources :users, only: %i[index show new create]
  get  :sign_up,  to: "users#new", as: :sign_up
  post :sign_up,  to: "users#create"

  namespace :settings do
    root to: redirect("/settings/profile")
    resource :profile
    resource :account
    resource :password
    resource :security
    resource :one_time_password
    resources :webauthn_credentials
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
