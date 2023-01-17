# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
Rails.application.routes.draw do
  root to: "home#index"

  scope :sign_in, as: :sign_in do
    scope "(:method)" do
      get  :/, to: "sessions#new"
      post :/, to: "sessions#create"
    end

    scope "idp/:provider", as: :idp, controller: "sessions/idp" do
      post :/, action: :new
      get :setup
      match :callback, via: %i[get post]
    end
  end
  post :sign_out, to: "sessions#destroy", as: :sign_out

  scope :sign_up, as: :sign_up do
    get  :/,  to: "users#new"
    post :/,  to: "users#create"
  end

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
# rubocop:enable Metrics/BlockLength
