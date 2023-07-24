# frozen_string_literal: true

module Settings
  class PasskeysController < BaseController
    before_action :set_passkey, only: %i[show update destroy]

    def new
      @passkey = @user.passkeys.new
    end

    def create
      @passkey = @user.passkeys.new(passkey_params)

      if @passkey.save
        redirect_to settings_security_url
      else
        render action: :new, status: :unprocessable_entity
      end
    end

    def show; end

    def destroy
      @passkey.destroy

      redirect_to settings_security_url
    end

    private

    def set_passkey
      @passkey = @user.passkeys.find(params[:id])
    end

    def passkey_params
      params.required(:passkey).permit(:title, :credential_json)
    end
  end
end
