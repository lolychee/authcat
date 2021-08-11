class Settings::OneTimePasswordsController < SettingsController
  around_action { |_controller, action| with_saved_state(@user, getter: :enable_one_time_password_saved_state, &action) }

  def show
  end

  def create
    render :show
  end

  def update
    if @user.enable_one_time_password(one_time_password_params)
      redirect_to settings_security_url
    else
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
