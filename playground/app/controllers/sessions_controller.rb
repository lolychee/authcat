# frozen_string_literal: true

class SessionsController < ApplicationController
  before_action :set_new_session, only: %i[new create omniauth]
  before_action :set_session, only: %i[show destroy]
  skip_before_action :verify_authenticity_token, only: :omniauth
  around_action(only: %i[create]) do |_controller, action|
    with_saved_state(@session, unless: :sign_in_completed?, &action)
  end

  # GET /sign_in
  def new; end

  def show; end

  # POST /sign_in
  def create(params = nil)
    respond_to do |format|
      if @session.sign_in(params || session_params)
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

  def omniauth
    create({ sign_in_step: :omniauth_hash, omniauth_hash: request.env["omniauth.auth"], remember_me: true })
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
    @session = current_session || Session.new
  end

  # Only allow a list of trusted parameters through.
  def session_params
    params.required(:session).permit(:login, :email, :phone_number, :password_challenge, :one_time_password_challenge,
                                     :recovery_codes_challenge, :remember_me, :switch_to)
  end
end
