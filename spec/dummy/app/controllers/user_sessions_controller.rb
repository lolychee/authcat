# frozen_string_literal: true

class UserSessionsController < ApplicationController
  before_action :set_tfa_user, only: [:tfa, :tfa_verify]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.sign_in(via: :password)
      if @user.tfa_verify_needed?
        authenticator[:tfa_user] = [@user, expires: 5.minutes.from_now]
        redirect_to tfa_sign_in_path
        return
      end

      authenticator[:cookies] = [@user, expires: @user.remember_me ? User::REMEMBER_ME_DURATION.from_now : nil]

      redirect_to root_url, flash: { success: "You have successfully signed in." }
    else
      render :new
    end
  end

  def tfa
    render :tfa
  end

  def tfa_verify
    @user.attributes = user_params

    if @user.sign_in(via: :tfa_code)
      authenticator.delete(:tfa_user)

      authenticator[:cookies] = [@user, expires: @user.remember_me ? User::REMEMBER_ME_DURATION.from_now : nil]

      redirect_to root_url, flash: { success: "You have successfully signed in." }
    else
      render :tfa
    end
  end

  def destroy
    authenticator.delete(:cookies)

    redirect_to root_url, flash: { info: "You have successfully signed out." }
  end

  private

    def user_params
      params.require(:user).permit(:identifier, :password, :remember_me, :tfa_code)
    end

    def set_tfa_user
      @user = authenticator[:tfa_user]
      redirect_to sign_in_path unless @user
    end
end
