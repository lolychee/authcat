class Account::PasswordsController < AccountController
  def show
  end

  def update
    @user.attributes = password_params

    if @user.change_password
      flash.now[:success] = "Your password has been successfully updated."
    end

    render :show
  end

  private

    def password_params
      params.require(:password).permit(:current_password, :password, :password_confirmation)
    end
end
