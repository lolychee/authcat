class Account::ResetPasswordController < ApplicationController
  def new
  end

  def create
    @user.attributes = reset_password_params

    if @user.reset_password
      flash["header.success"] = ""
      redirect_to sign_in_path
    else
      render :new
    end
  end

  private

    def reset_password_params
      params.require(:resett_password).permit(:password, :password_confirmation)
    end

    def set_user
    end
end
