class Settings::OneTimePasswordsController < SettingsController
  def show
  end

  def create
    render :show
  end

  def update
    @user.attributes = saved_state

    if @user.update_one_time_password(one_time_password_params)
      clear_saved_state

      redirect_to settings_security_url
    else
      self.saved_state = @user.as_json(only: %i[update_one_time_password_step backup_codes_digest one_time_password_secret])

      render action: :show, status: :unprocessable_entity
    end
  end

  def destroy
    @user.disable_one_time_password!

    redirect_to settings_security_url
  end

  private

  def one_time_password_params
    params.fetch(:one_time_password, {}).permit(:one_time_password_attempt)
  end
end
