# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  authcat do
    strategy :cookies, User, key: :access_token
  end

  before_action { console if params[:console] }

  # rescue_from(Authcat::Errors::IdentityNotFound, with: :render_error_unauthorized)

  def current_user
    return @current_user if instance_variable_defined?(:@current_user)
    @current_user = authenticator[:cookies]
  end

  def user_signed_in?
    !current_user.nil?
  end
  helper_method :current_user, :user_signed_in?

  def render_error_unauthorized
    if request.get?
      redirect_to sign_in_path(redirect_to: request.fullpath), flash: { warning: "You need to sign in or sign up." }
    else
      render text: "401 Unauthorized", status: :unauthorized
    end
  end
end
