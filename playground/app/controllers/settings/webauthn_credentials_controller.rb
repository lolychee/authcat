# frozen_string_literal: true

module Settings
  class WebAuthnCredentialsController < BaseController
    before_action :set_webauthn_credential, only: %i[show update destroy]

    def new
      @webauthn_credential = @user.webauthn_credentials.new
    end

    def create
      @webauthn_credential = @user.webauthn_credentials.new(webauthn_credential_params)

      if @webauthn_credential.save
        redirect_to settings_security_url
      else
        render action: :new, status: :unprocessable_entity
      end
    end

    def show; end

    def destroy
      @webauthn_credential.destroy

      redirect_to settings_security_url
    end

    private

    def set_webauthn_credential
      @webauthn_credential = @user.webauthn_credentials.find(params[:id])
    end

    def webauthn_credential_params
      params.required(:webauthn_credential).permit(:name, :credential_json)
    end
  end
end
