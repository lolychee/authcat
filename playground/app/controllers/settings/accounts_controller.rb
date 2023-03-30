# frozen_string_literal: true

module Settings
  class AccountsController < BaseController
    def show; end

    def update
      if @user.update_profile(account_params)
        render action: :show, status: :ok
      else
        render action: :show, status: :unprocessable_entity
      end
    end

    private

    def account_params
      params.required(:account).permit(:username, :email, :phone_number)
    end
  end
end
