# frozen_string_literal: true

class Account::PasswordsController < AccountController
  def show
  end

  def update
    if @user.update_password(user_params.merge(old_password_needed: true))
      flash.now[:success] = "Your password has been successfully updated."
    end

    render :show
  end

  private

    def user_params
      params.require(:user).permit(:old_password, :password, :password_confirmation)
    end
end
