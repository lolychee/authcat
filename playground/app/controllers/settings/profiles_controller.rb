class Settings::ProfilesController < SettingsController
  def show
  end

  def update
    if @user.update(profile_params)
      render action: :show, status: :ok
    else
      render action: :show, status: :unprocessable_entity
    end
  end

  private

  def profile_params
    params.required(:profile).permit(:avatar, :name, :about)
  end
end
