# frozen_string_literal: true

module Settings
  class ProfilesController < BaseController
    def show; end

    def update
      if @user.update_profile(profile_params)
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
end
