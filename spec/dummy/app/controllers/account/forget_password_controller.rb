class Account::ForgetPasswordController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(forget_password_params)

    if @user.validate(:forget_password)
      session[:send_reset_password_token] = @user.to_signed_global_id(for: :send_reset_password, expires_in: 15.minutes).to_s
      redirect_to account_send_reset_password_path
    else
      render :new
    end
  end

  private

    def forget_password_params
      params.require(:forget_password).permit(:email)
    end
end
