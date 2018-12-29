# frozen_string_literal: true

Rails.application.routes.draw do
  root to: "home#index"

  get  "sign_up",     to: "users#new",              as: :sign_up
  post "sign_up",     to: "users#create"
  get  "sign_in",     to: "user_sessions#new",      as: :sign_in
  post "sign_in",     to: "user_sessions#create"
  get  "sign_in/tfa", to: "user_sessions#tfa",      as: :tfa_sign_in
  post "sign_in/tfa", to: "user_sessions#tfa_verify"
  post "sign_out",    to: "user_sessions#destroy",  as: :sign_out

  resource :reset_password, controller: "user_reset_password", only: [:new, :create, :show, :update]

  namespace :account do
    root to: "profiles#show"
    resource :profile,  only: [:show, :update]
    resource :password, only: [:show, :update]
    resource :two_factor_auth, only: [:show, :update]
  end

  [:authenticated].each do |action|
    get action, controller: "home", action: action, as: action
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
