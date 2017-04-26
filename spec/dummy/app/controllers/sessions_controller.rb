class SessionsController < ApplicationController
  # before_action :authenticate_user!

  def new
    @session = Session.new
  end

  def create
    @session = Session.new(session_params)

    if @session.save
      authenticator.sign_in(@session.user, remember_me: @session.remember_me)

      redirect_to params[:redirect_to] || root_url, flash: { success: "You have successfully signed in." }
    else
      render :new
    end
  end

  def destroy
    authenticator.sign_out

    redirect_to root_url, flash: { info: "You have successfully signed out." }
  end

  private

    def session_params
      params.require(:session).permit(:email, :password, :remember_me)
    end
end
