class Settings::OneTimePasswordsController < SettingsController
  def show
  end

  def create
    render :show
  end

  def update
    @user.attributes = saved_state || {}

    if @user.update_one_time_password(one_time_password_params)
      redirect_to settings_security_url
    else
      render action: :show, status: :unprocessable_entity
    end

    self.saved_state = @user.update_one_time_password_saved_state
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
