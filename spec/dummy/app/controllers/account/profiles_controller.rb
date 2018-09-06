# frozen_string_literal: true

class Account::ProfilesController < AccountController
  def show
  end

  def update
    if @user.update(profile_params)
      flash.now[:success] = "Your profile has been successfully updated."
    end

    render :show
  end

  private

    def profile_params
      params.require(:profile).permit(:name, :bio)
    end
end
