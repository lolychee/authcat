class Settings::PasswordsController < SettingsController
  def show
  end

  def update
    if @user.change_password(change_password_params)
      render action: :show, status: :ok
    else
      render action: :show, status: :unprocessable_entity
    end
  end

  private

  def change_password_params
    params.required(:change_password).permit(:password_attempt, :new_password, :new_password_confirmation)
  end
end
