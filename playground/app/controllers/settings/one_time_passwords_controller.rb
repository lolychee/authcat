# frozen_string_literal: true

module Settings
  class OneTimePasswordsController < BaseController
    before_action :recovery_codes_required!

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

    def recovery_codes_required!
      return if @user.recovery_codes.present?

      redirect_to settings_recovery_codes_url(back_to: settings_one_time_password_path)
    end

    def one_time_password_params
      params.required(:one_time_password).permit(:one_time_password_attempt)
    end
  end
end
