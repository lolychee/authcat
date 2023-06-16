# frozen_string_literal: true

class UserSessionsController < ApplicationController
  before_action :set_user_session

  skip_before_action :verify_authenticity_token, if: -> { request.env["omniauth.strategy"]&.on_callback_path? }

  use OmniAuth::Builder do
    klass = User.reflect_on_association(:idp_credentials).klass

    options klass.omniauth_options.merge(path_prefix: "/sign_in")

    klass.omniauth_providers.each_value do |name, args, opts, block|
      provider name, *args, **opts, &block
    end
  end

  # GET /sign_in(/:auth_method)
  def new; end

  # POST /sign_in(/:auth_method)
  def create
    respond_to do |format|
      if @user_session.authenticate!(user_session_params)
        if @user_session.authenticated?
          Current.session = @user_session
          format.html { redirect_to root_url }
        else
          format.html { render :new, status: :accepted }
        end
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # POST /sign_out
  def destroy
    @user_session&.sign_out

    respond_to do |format|
      format.html { redirect_to root_url }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user_session
    @user_session = current_session || UserSession.new
    @user_session.tap do |s|
      if request.env["omniauth.auth"].present?
        s.assign_attributes(auth_method: "idp", idp_credential: request.env["omniauth.auth"])
      elsif !s.valid_auth_method?(params[:auth_method])
        redirect_to action: :new, auth_method: s.default_auth_method
      end
      s.assign_attributes({ auth_method: s.default_auth_method }.merge(params.permit(:auth_method)))
    end
  end

  # Only allow a list of trusted parameters through.
  def user_session_params
    params.required(:user_session).permit(
      :login, :email, :phone_number,
      :password, :one_time_password, :recovery_code,
      :remember_me
    )
  end
end
