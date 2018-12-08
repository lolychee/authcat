# frozen_string_literal: true

class UserResetPasswordController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.find_by_identifier(user_params[:identifier]) do |u|
      u.errors.add(:identifier, "not found")
    end

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
  end

  private

    def user_params
      params.require(:user).permit(:identifier, :password, :password_confirmation)
    end
end
