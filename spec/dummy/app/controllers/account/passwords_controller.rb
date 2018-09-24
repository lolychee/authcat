# frozen_string_literal: true

class Account::PasswordsController < AccountController
  def show
  end

  def update
    if @user.reset_password(user_reset_password_params)
      flash.now[:success] = "Your password has been successfully updated."
    end

    render :show
  end

  private

    def user_reset_password_params
      params.require(:user_reset_password).permit(:current_password, :password, :password_confirmation)
    end
end
