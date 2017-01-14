class Account::PasswordController < AccountController
  def show
  end

  def update
    @user.attributes = password_params

    if @user.save(context: :change_password)
      flash.now['account_password_form.success'] = 'Your password has been successfully updated.'
    end

    render :show
  end

  private

    def password_params
      params.require(:password).permit(:old_password, :password, :password_confirmation)
    end
end
