# frozen_string_literal: true

class UserResetPasswordController < ApplicationController
  def new
    @user_reset_password = UserResetPassword.new
  end

  def create
    @user_reset_password = UserResetPassword.new(user_reset_password_params)

    if @user_reset_password.send_verification
      @url = reset_password_url(token: @user_reset_password.generate_token)
      flash[:success] = "Your reset password verification has been successfully sent."
    end

    render :new
  end

  def show
    token = params[:user_reset_password].try(:[], :token) || params[:token]
    @user_reset_password = UserResetPassword.new(token: token)
  end

  def update
    @user_reset_password = UserResetPassword.new(user_reset_password_params.merge(skip_current_password: true))

    if @user_reset_password.reset_password
      flash[:success] = "Your password has been successfully updated."
      redirect_to root_path
    else
      render :show
    end
  end

  private

    def user_reset_password_params
      params.require(:user_reset_password).permit(:token, :identifier, :password, :password_confirmation)
    end
end
