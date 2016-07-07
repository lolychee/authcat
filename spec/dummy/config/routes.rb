Rails.application.routes.draw do
  namespace :simple do
    root to: 'home#index'

    get   :sign_up, to: 'sign_up#new', as: :sign_up
    post  :sign_up, to: 'sign_up#create'

    get   :sign_in, to: 'sessions#new', as: :sign_in
    post  :sign_in, to: 'sessions#create'

    delete :sign_out, to: 'sessions#destroy', as: :sign_out

    [:authenticated].each do |action|
      get action, controller: 'home', action: action, as: action
    end
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
