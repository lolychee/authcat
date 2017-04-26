class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  authenticator :user

  before_action { console if params[:console] }

  rescue_from(Authcat::Errors::IdentityNotFound, with: :render_error_unauthorized)

  def render_error_unauthorized
    if request.get?
      redirect_to sign_in_path(redirect_to: request.fullpath), flash: { warning: "You need to sign in or sign up." }
    else
      render text: "401 Unauthorized", status: :unauthorized
    end
  end
end
