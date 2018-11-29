# frozen_string_literal: true

class Account::TwoFactorAuthenticationsController < AccountController
  def show
    @user_two_factor_authentication = UserTwoFactorAuthentication.new(enable_otp: true)
  end

  def update
    @user_two_factor_authentication = UserTwoFactorAuthentication.new(user_two_factor_authentication_params.merge(user: @user))
    if @user_two_factor_authentication.save
      flash.now[:success] = "Your two-factor authentication has been successfully updated."
    end

    render :show
  end

  private

    def user_two_factor_authentication_params
      params.require(:user_two_factor_authentication).permit(:enable_otp, :otp_code)
    end
end
