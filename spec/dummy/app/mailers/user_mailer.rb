class UserMailer < ApplicationMailer

  def welcome_mail(user)
    @user = user

    mail subject: 'Welcome to join Dummy'
  end

  def reset_password_mail(user)
    @user = user

    mail subject: 'Reset Password'
  end
end
