# frozen_string_literal: true

class Account::TwoFactorAuthsController < AccountController
  def show
  end

  def update
    @user.attributes = user_params
    if @user.update_tfa
      flash.now[:success] = "Your two-factor auth has been successfully updated."
    end

    render :show
  end

  private

    def user_params
      params.require(:user).permit(:tfa, :tfa_code)
    end
end
