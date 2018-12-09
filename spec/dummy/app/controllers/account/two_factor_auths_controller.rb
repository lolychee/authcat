# frozen_string_literal: true

class Account::TwoFactorAuthsController < AccountController
  def show
  end

  def update
    if @user.update_tfa(user_params)
      flash.now[:success] = "Your two-factor auth has been successfully updated."
    end

    render :show
  end

  private

    def user_params
      params.require(:user).permit(:tfa, :tfa_code).tap do |attributes|
        attributes[:tfa] = ActiveModel::Type::Boolean.new.cast(attributes[:tfa]) if attributes[:tfa]
      end
    end
end
