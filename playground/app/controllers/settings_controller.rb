class SettingsController < ApplicationController
  include Encryptor

  before_action :set_user

  def set_user
    @user = User.first
  end
end
