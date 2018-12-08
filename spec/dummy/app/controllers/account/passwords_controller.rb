# frozen_string_literal: true

class Account::PasswordsController < AccountController
  def show
  end

  def update
    if @user.update_password(user_params.merge(current_password_required: true))
      flash.now[:success] = "Your password has been successfully updated."
    end

    render :show
  end

  private

    def user_params
      params.require(:user).permit(:current_password, :password, :password_confirmation)
    end
end
