class SessionsController < ApplicationController
  # before_action :authenticate_user!

  def new
    @user = User.new
  end

  def create
    @user = User.new(session_params)

    if @user.validate(:sign_in)
      authenticator.sign_in(@user)

      redirect_to session.delete(:back_to) || root_url, flash: { success: "You have successfully signed in." }
    else
      render :new
    end
  end

  def destroy
    authenticator.sign_out

    redirect_to root_url, flash: { info: "You have successfully signed out." }
  end

  private

    def session_params
      params.require(:session).permit(:email, :password, :remember_me)
    end
end
