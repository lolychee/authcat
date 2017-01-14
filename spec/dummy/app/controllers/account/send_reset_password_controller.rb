class Account::SendResetPasswordController < ApplicationController
  before_action :set_user

  def new
  end

  def create
    @user.attributes = send_reset_password_params
    if @user.send_reset_password
      render :success
    else
      render :new
    end
  end

  private

    def set_user
      @user = GlobalID::Locator.locate_signed(session[:send_reset_password_token], for: :send_reset_password)
      redirect_to account_forget_password_path unless @user
    end

    def send_reset_password_params
      params.require(:send_reset_password).permit(:method)
    end
end
