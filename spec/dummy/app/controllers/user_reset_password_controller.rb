# frozen_string_literal: true

class UserResetPasswordController < ApplicationController
  def new
    @user_reset_password = UserResetPassword.new
  end

  def create
    @user_reset_password = UserResetPassword.new(user_reset_password_params)

    if @user.validate(:forget_password)
      session[:send_reset_password_token] = @user.to_signed_global_id(for: :send_reset_password, expires_in: 15.minutes).to_s
      redirect_to account_send_reset_password_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    @user_reset_password = UserResetPassword.new(user_reset_password_params)
  end

  private

    def user_reset_password_params
      params.require(:user_reset_password).permit(:identifier, :code, :password, :password_confirmation)
    end
end
