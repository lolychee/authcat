class SessionsController < ApplicationController
  before_action :set_session, only: %i[ show update destroy ]

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
    @session = Session.new(session_params)

    respond_to do |format|
      if @session.sign_in
        self.current_session = @session

        format.html { redirect_to root_url }
        format.json { render :show, status: :created, location: @session }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @session.errors, status: :unprocessable_entity }
      end
    end
  end

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
    def set_session
      @session = Current.session
    end

    # Only allow a list of trusted parameters through.
    def session_params
      params.required(:session).permit(:saved_state, :login, :email, :phone_country_code, :phone_national, :password_attempt, :one_time_password_attempt, :recovery_code_attempt, :remember_me).tap do |whitelist|
        whitelist.reverse_merge!(encryptor.decrypt_and_verify(whitelist.delete(:saved_state))) if whitelist.key?(:saved_state)
      rescue ActiveSupport::MessageEncryptor::InvalidMessage => _e
        nil
      end
    end
end
