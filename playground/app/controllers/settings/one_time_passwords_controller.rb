# frozen_string_literal: true

module Settings
  class OneTimePasswordsController < SettingsController
    around_action(only: %i[create update]) do |_controller, action|
      with_saved_state(@user, unless: :enable_one_time_password_completed?, &action)
    end

    def show; end

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
end
