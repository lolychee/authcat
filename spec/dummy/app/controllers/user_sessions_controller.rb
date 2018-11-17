# frozen_string_literal: true

class UserSessionsController < ApplicationController
  # before_action :authenticate_user!

  def new
    @user_session = UserSession.new
  end

  def create
    @user_session = UserSession.new(user_session_params)

    if @user_session.save
      user_sign_in(@user_session.user, @user_session.remember_me)

      redirect_to params[:redirect_to] || root_url, flash: { success: "You have successfully signed in." }
    else
      render :new
    end
  end

  def destroy
    user_sign_out

    redirect_to root_url, flash: { info: "You have successfully signed out." }
  end

  private

    def user_session_params
      params.require(:user_session).permit(:identifier, :password, :remember_me, :token, :otp_code)
    end
end
