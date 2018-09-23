# frozen_string_literal: true

class Account::PasswordsController < AccountController
  def show
    @user_reset_password = UserResetPassword.new
  end

  def update
    @user_reset_password = UserResetPassword.new(user_reset_password_params.merge(user: current_user))

    if @user_reset_password.save
      flash.now[:success] = "Your password has been successfully updated."
    end

    render :show
  end

  private

    def user_reset_password_params
      params.require(:user_reset_password).permit(:current_password, :password, :password_confirmation)
    end
end
