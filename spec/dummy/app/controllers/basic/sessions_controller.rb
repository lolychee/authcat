class Basic::SessionsController < ApplicationController

  module Auth
    extend ActiveSupport::Concern

    included do
      helper_method :current_user, :user_signed_in?
    end

    module ClassMethods
      def authcat(name, klass, **options)

      end
    end

    def user_auth
      @user_auth ||= ApplicationAuthenticator.new(request)
    end

    def user_signed_in?
      user_auth.signed_in?
    end

    def current_user
      user_auth.user
    end

    def authenticate_user!
      user_auth.authenticate!
    end
  end

  include Auth


  # before_action :authenticate_user!

  def status
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.validate(:sign_in)
      user_auth.sign_in(@user)
      flash.now[:success] = 'successly sign in.'
      redirect_to basic_status_url
    else
      render :new
    end
  end

  def destroy
    user_auth.sign_out

    redirect_to basic_status_url
  end

  private

    def user_params
      params.require(:user).permit(:email, :password)
    end

end
