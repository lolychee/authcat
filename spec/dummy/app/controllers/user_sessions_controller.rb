class UserSessionsController < ApplicationController
  # before_action :authenticate_user!

  def new
    @user_session = UserSession.new
  end

  def create
    @user_session = UserSession.new(user_session_params)

    if @user_session.save
      authenticator[:cookies] = @user_session.user if @user_session.remember_me

      redirect_to params[:redirect_to] || root_url, flash: { success: "You have successfully signed in." }
    else
      render :new
    end
  end

  def destroy
    authenticator.delete(:cookies)

    redirect_to root_url, flash: { info: "You have successfully signed out." }
  end

  private

    def user_session_params
      params.require(:user_session).permit(:email, :password, :remember_me)
    end
end
