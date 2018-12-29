# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  authcat do
    strategy :cookies, User, key: :access_token
    strategy :cookies, User, key: :tfa_user_token, as: :tfa_user
  end

  before_action { console if params[:console] }

  concerning :Authentication do
    included do
      helper_method :current_user
    end

    def current_user
      return @current_user if instance_variable_defined?(:@current_user)
      @current_user = authenticator[:cookies]
    end

    def find_user(id = params[:id])
      @user = User.find(id)
    end
  end

  concerning :Authorization do
    included do
      # rescue_from(Authcat::Errors::IdentityNotFound, with: :render_error_unauthorized)
    end

    def authenticate_user!
      current_user
    end

    def render_error_unauthorized
      if request.get?
        redirect_to sign_in_path(redirect_to: request.fullpath), flash: { warning: "You need to sign in or sign up." }
      else
        render text: "401 Unauthorized", status: :unauthorized
      end
    end
  end
end
