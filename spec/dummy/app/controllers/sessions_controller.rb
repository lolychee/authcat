class SessionsController < ApplicationController

  # before_action :authenticate_user!

  def new
    @user = User.new
  end

  def create
    @user = User.new(session_params)

    if @user.validate(:sign_in)
      user_auth.sign_in(@user)
      flash[:success] = 'You have successfully signed in.'

      redirect_to session.delete(:back_to) || root_url
    else
      render :new
    end
  end

  def destroy
    user_auth.sign_out
    flash[:info] = 'You have successfully signed out.'

    redirect_to root_url
  end

  private

    def session_params
      params.require(:session).permit(:email, :password, :remember_me)
    end

end
