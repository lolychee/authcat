# frozen_string_literal: true

module Settings
  class RecoveryCodesController < BaseController
    def show; end

    def update
      if @user.enable_recovery_codes(recovery_codes_params)
        redirect_to params[:back_to] || settings_security_url
      else
        render action: :show, status: :unprocessable_entity
      end
    end

    def destroy
      @user.disable_recovery_codes!

      redirect_to settings_security_url
    end

    private

    def recovery_codes_params
      params.require(:recovery_codes).permit(:one_time_password_attempt)
    end
  end
end
