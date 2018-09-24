# frozen_string_literal: true

class Account::ProfilesController < AccountController
  def show
  end

  def update
    if @user.update(user_profile_params)
      flash.now[:success] = "Your profile has been successfully updated."
    end

    render :show
  end

  private

    def user_profile_params
      params.require(:user_profile).permit(:name, :bio)
    end
end
