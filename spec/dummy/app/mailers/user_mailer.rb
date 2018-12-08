# frozen_string_literal: true

class UserMailer < ApplicationMailer
  self.default_url_options = { host: 'example.com' }

  def welcome_mail
    @user = params[:user]

    mail subject: "Welcome to join Dummy"
  end

  def reset_password_verification_mail
    @user = params[:user]
    @url = reset_password_url(token: User.tokenize(@user, expires_in: 30.minutes))

    mail to: @user.email, subject: "Reset Password Verification"
  end
end
