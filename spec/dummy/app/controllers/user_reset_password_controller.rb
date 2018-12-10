# frozen_string_literal: true

class UserResetPasswordController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.send_reset_password_verification
      render :sent
    else
      render :new
    end
  end

  def show
    @user = User.untokenize(params[:token])
  rescue
    render :expired
  end

  def update
    @user = User.untokenize(params[:token])

    if @user.update_password(user_params)
      flash[:success] = "Your password has been successfully updated."
      redirect_to root_path
    else
      render :show
    end
  rescue
    render :expired
  end

  private

    def user_params
      params.require(:user).permit(:identifier, :password, :password_confirmation)
    end
end
