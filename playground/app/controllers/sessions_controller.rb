class SessionsController < ApplicationController
  before_action :set_session, only: %i[ show update ]

  # GET /sign_in
  def new
    @session = Session.new
  end

  # POST /sign_in
  def create
    @session = Session.new(session_params)

    respond_to do |format|
      if @session.user_authenticate
        format.html { redirect_to root_url, notice: "Password was successfully created." }
        format.json { render :show, status: :created, location: @session }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @session.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_session
      @session = SignIn::Password.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def session_params
      params.required(:session).permit(:login, :email, :phone_country_code, :phone_national, :user_token, :password_attempt, :one_time_code_attempt, :remember_me)
    end
end
