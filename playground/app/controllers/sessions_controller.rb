# frozen_string_literal: true

class SessionsController < ApplicationController
  before_action :set_new_session, only: %i[new create]
  before_action :set_session, only: %i[destroy]
  around_action(only: %i[create]) do |_controller, action|
    with_saved_state(@session, unless: :sign_in_completed?, &action)
  end

  skip_before_action :verify_authenticity_token, if: -> { request.env["omniauth.strategy"]&.on_callback_path? }

  use OmniAuth::Builder do
    configure do |config|
      config.path_prefix = "/sign_in"
    end

    provider :developer if Rails.env.development?

    if true # ENV.key?("OMNIAUTH_TWITTER_KEY")
      provider :twitter, ENV.fetch("OMNIAUTH_TWITTER_KEY", nil),
               ENV.fetch("OMNIAUTH_TWITTER_SECRET", nil)
    end

    if true # ENV.key?("OMNIAUTH_GITHUB_KEY")
      provider :github, ENV.fetch("OMNIAUTH_GITHUB_KEY", nil),
               ENV.fetch("OMNIAUTH_GITHUB_SECRET", nil)
    end

    if true # ENV.key?("OMNIAUTH_GOOGLE_KEY")
      provider :google_oauth2, ENV.fetch("OMNIAUTH_GOOGLE_KEY", nil),
               ENV.fetch("OMNIAUTH_GOOGLE_SECRET", nil)
    end
  end


  # GET /sign_in(/:auth_method)
  def new; end

  # POST /sign_in(/:auth_method)
  def create
    respond_to do |format|
      if @session.sign_in(session_params)
        if @session.sign_in_completed?

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
    @session.sign_out

    respond_to do |format|
      format.html { redirect_to root_url }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_new_session
    @session = Session.new
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_session
    @session = current_session || Session.new(auth_method: params[:auth_method])
  end

  # Only allow a list of trusted parameters through.
  def session_params
    params.required(:user_session).permit(
      :login, :email, :phone_number,
      :password_challenge, :one_time_password_challenge, :recovery_codes_challenge,
      :remember_me
    ).merge(auth_method: params[:auth_method]).tap do |hash|
      hash[:idp] = request.env["omniauth.auth"]
    end
  end
end
