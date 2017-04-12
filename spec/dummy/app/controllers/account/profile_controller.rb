class Account::ProfileController < AccountController
  def show
  end

  def update
    if @user.update(profile_params)
      flash.now["account_profile_form.success"] = "Your profile has been successfully updated."
    end

    render :show
  end

  private

    def profile_params
      params.require(:profile).permit(:name, :bio)
    end
end
