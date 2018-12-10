# frozen_string_literal: true

class UserSessionsController < ApplicationController
  # before_action :authenticate_user!

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.sign_in
      user_sign_in(@user, @user.remember_me)

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

    def user_params
      params.require(:user).permit(:identifier, :password, :remember_me, :tfa_code)
    end
end
