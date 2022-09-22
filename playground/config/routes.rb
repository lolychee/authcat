# frozen_string_literal: true

Rails.application.routes.draw do
  root to: "home#index"

  resource :session, only: %i[show create destroy]
  get  :sign_in,  to: "sessions#new", as: :sign_in
  post :sign_in,  to: "sessions#create"
  post :sign_out, to: "sessions#destroy", as: :sign_out
  match "/auth/:provider/callback", to: "sessions#omniauth", via: %i[get post]

  resources :users
  get  :sign_up,  to: "users#new", as: :sign_up
  post :sign_up,  to: "users#create"

  namespace :settings do
    root to: redirect("/settings/profile")
    resource :profile
    resource :account
    resource :password
    resource :security
    resource :one_time_password
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
