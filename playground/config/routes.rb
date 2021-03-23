Rails.application.routes.draw do
  root to: "home#index"

  get :sign_in, to: "sessions#new", as: :sign_in
  post :sign_in, to: "sessions#create"
  post :sign_out, to: "sessions#destroy", as: :sign_out

  resources :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
