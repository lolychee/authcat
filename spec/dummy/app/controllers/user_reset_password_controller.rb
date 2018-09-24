# frozen_string_literal: true

class UserResetPasswordController < ApplicationController
  before_action :find_user, only: [:show, :update]

  def new
    @user_reset_password_verification = UserResetPasswordVerification.new
  end

  def create
    @user_reset_password_verification = UserResetPasswordVerification.new(user_reset_password_verification_params)

    if @user_reset_password_verification.save
      session[:user_reset_password_token] = @user_reset_password_verification.token
      flash[:success] = "Your reset password verification has been successfully sent."
    end

    render :new
  end

  def show
  end

  def update
    if @user.reset_password(user_reset_password_params.merge(skip_current_password: true))
      session.delete(:user_reset_password_token)
      flash[:success] = "Your password has been successfully updated."
      redirect_to root_path
    else
      render :show
    end
  end

  private

    def find_user(token = session[:user_reset_password_token])
      @user = UserResetPasswordVerification.locate(token)
    end

    def user_reset_password_verification_params
      params.require(:user_reset_password_verification).permit(:identifier)
    end

    def user_reset_password_params
      params.require(:user_reset_password).permit(:identifier, :code, :password, :password_confirmation)
    end
end
