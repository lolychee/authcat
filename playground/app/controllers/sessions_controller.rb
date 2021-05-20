class SessionsController < ApplicationController
  before_action :set_session, only: %i[ show update destroy ]
  skip_before_action :verify_authenticity_token, only: :omniauth

  def omniauth
    @session = Session.find_or_create_from_auth_hash(auth_hash)
    self.current_session = @session

    respond_to do |format|
      format.html { redirect_to root_url }
      format.json { render :show, status: :created, location: @session }
    end
  end

  # GET /sign_in
  def new
    @session = Session.new
  end

  # GET /session
  def show
  end

  # POST /sign_in
  # POST /session
  def create
    @session = Session.new(saved_state || {})

    respond_to do |format|
      if @session.sign_in(session_params)
        self.saved_state = nil

        self.current_session = @session

        format.html { redirect_to root_url }
        format.json { render :show, status: :created, location: @session }
      else
        self.saved_state = @session.as_json(only: %i[step auth_type user_id])

        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @session.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /session
  # POST /sign_out
  def destroy
    @session.sign_out
    self.current_session = nil

    respond_to do |format|
      format.html { redirect_to root_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_session
      @session = current_session
    end

    # Only allow a list of trusted parameters through.
    def session_params
      params.required(:session).permit(:auth_type, :submit, :login, :email, :phone_country_code, :phone_national, :password, :one_time_password, :recovery_code, :remember_me)
    end

    def auth_hash
      request.env['omniauth.auth']
    end
end
