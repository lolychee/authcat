class Simple::SessionsController < Simple::BaseController

  # before_action :authenticate_user!

  def new
    @user = Simple::User.new
  end

  def create
    @user = Simple::User.new(session_params)

    if @user.validate(:sign_in)
      user_auth.sign_in(@user)
      flash[:success] = 'You have successfully signed in.'

      redirect_to session.delete(:back_to) || simple_root_url
    else
      render :new
    end
  end

  def destroy
    user_auth.sign_out
    flash[:success] = 'You have successfully signed out.'

    redirect_to simple_root_url
  end

  private

    def session_params
      params.require(:session).permit(:email, :password, :remember_me)
    end

end
