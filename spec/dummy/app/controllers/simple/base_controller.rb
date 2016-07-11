class Simple::BaseController < ApplicationController

  layout 'simple'

  authcat :user

  rescue_from(Authcat::IdentityNotFound, with: :error_unauthorized)

  def error_unauthorized
    if request.get?
      session[:back_to] = request.path
      flash[:warning] = 'You need to sign in or sign up.'

      redirect_to simple_sign_in_path
    else
      render text: '401 Unauthorized', status: :unauthorized
    end
  end
end
