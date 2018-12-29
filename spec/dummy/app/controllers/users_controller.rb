# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :find_user, only: [:show]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      authenticator[:cookies] = [@user, expires: User::REMEMBER_ME_DURATION.from_now]

      redirect_to root_url, flash: { success: "Your account has been successfully created." }
    else
      render :new
    end
  end

  def show
  end

  private

    def user_params
      params.require(:user).permit(:email, :password)
    end
end
