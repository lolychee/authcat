class Settings::OneTimePasswordsController < SettingsController
  def show
  end

  def create
    render :show
  end

  def update
    if @user.update_one_time_password(one_time_password_params)
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
    params.required(:one_time_password).permit(:saved_state, :one_time_password_attempt).tap do |whitelist|
      whitelist.reverse_merge!(encryptor.decrypt_and_verify(whitelist.delete(:saved_state))) if whitelist.key?(:saved_state)
    rescue ActiveSupport::MessageEncryptor::InvalidMessage => _e
      nil
    end
  end
end
