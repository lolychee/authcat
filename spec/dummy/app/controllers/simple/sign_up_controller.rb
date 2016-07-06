class Simple::SignUpController < Simple::BaseController

  def new
    @user = Simple::User.new
  end

  def create
    @user = Simple::User.new(user_params)

    if @user.save
      user_auth.sign_in(@user)
      flash[:success] = 'Your account has been successfully created.'

      redirect_to simple_root_url
    else
      render :new
    end
  end

  private

    def user_params
      params.require(:user).permit(:email, :password)
    end

end
