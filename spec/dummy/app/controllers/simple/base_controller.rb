class Simple::BaseController < ApplicationController

  layout 'simple'

  authcat :user, scope: :web

  def authenticate_user!
    super
  rescue Authcat::Unauthenticated
    if request.get?
      session[:back_to] = request.path
      redirect_to simple_sign_in_path
    else
      render 'errors/unauthenticated', status: :unauthenticated
    end
  end
end
