class SignUpController < ApplicationController

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      authenticator.sign_in(@user)
      flash[:success] = 'Your account has been successfully created.'

      redirect_to root_url
    else
      render :new
    end
  end

  private

    def user_params
      params.require(:user).permit(:email, :password)
    end

end
