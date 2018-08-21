class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  authenticator do
    strategy :session, User, key: :access_token
    strategy :cookies, User, key: :access_token
  end

  before_action { console if params[:console] }

  # rescue_from(Authcat::Errors::IdentityNotFound, with: :render_error_unauthorized)

  def current_user
    @current_user ||= (authenticator[:session] || authenticator[:cookies])
  end

  def signed_in?
    !current_user.nil?
  end
  helper_method :current_user, :signed_in?

  def render_error_unauthorized
    if request.get?
      redirect_to sign_in_path(redirect_to: request.fullpath), flash: { warning: "You need to sign in or sign up." }
    else
      render text: "401 Unauthorized", status: :unauthorized
    end
  end
end
