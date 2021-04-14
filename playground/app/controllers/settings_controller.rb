class SettingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user

  def set_user
    @user = current_user
  end
end
