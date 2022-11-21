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

  # GET /session
  def show; end

  # POST /sign_in
  # POST /session
  def create
    respond_to do |format|
      if @session.sign_in(session_params)
        if @session.sign_in_completed?

          format.html { redirect_to root_url }
          format.json { render :show, status: :created, location: @session }
        else
          format.html { render :new, status: :accepted }
          format.json { render :show, status: :accepted }
        end
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @session.errors, status: :unprocessable_entity }
      end
    end
  end
  alias omniauth create

  # DELETE /session
  # POST /sign_out
  def destroy
    @session.sign_out

    respond_to do |format|
      format.html { redirect_to root_url }
      format.json { head :no_content }
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
    case action_name
    when 'omniauth'
      {sign_in_step: :omniauth_hash, omniauth_hash: request.env["omniauth.auth"], remember_me: true}
    else
      params.required(:session).permit(:login, :email, :phone_number, :password_challenge, :one_time_password_challenge,
                                       :recovery_codes_challenge, :remember_me, :switch_to)
    end
  end
end
