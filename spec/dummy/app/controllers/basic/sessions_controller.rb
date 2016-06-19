class Basic::SessionsController < ApplicationController

  authcat :user

  # before_action :authenticate_user!

  def index
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.validate(:sign_in)
      user_auth.sign_in(@user)
      flash.now[:success] = 'successly sign in.'
      redirect_to basic_root_url
    else
      render :new
    end
  end

  def destroy
    user_auth.sign_out

    redirect_to basic_root_url
  end

  private

    def user_params
      params.require(:user).permit(:email, :password)
    end

end
