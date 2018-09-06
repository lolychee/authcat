# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :find_user

  def show
  end

  private

    def find_user(id = params[:id])
      @user = User.find(id)
    end
end
