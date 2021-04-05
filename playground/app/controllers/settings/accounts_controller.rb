class Settings::AccountsController < SettingsController
  def show
  end

  def update
    if @user.update_account(account_params)
      render action: :show, status: :ok
    else
      render action: :show, status: :unprocessable_entity
    end
  end

  private

  def account_params
    params.required(:account).permit(:username, :email, :phone_number)
  end
end
