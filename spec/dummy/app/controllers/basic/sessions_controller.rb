class Basic::SessionsController < ApplicationController

  module Auth
    extend ActiveSupport::Concern

    module ClassMethods
    end

    def auth
      @auth ||= ApplicationAuthenticator.new(request)
    end
  end

  include Auth

  def new
    @user_session = UserSession.new
  end

  def create
    @user_session = UserSession.new(user_session_params)

    if @user_session.create
      auth.sign_in(@user_session)
      redirect_to :back
    else
      render :new
    end
  end

  private

    def user_session_params
      params.require(:user_session).permit(:email, :password)
    end

end
