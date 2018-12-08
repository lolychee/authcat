# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
  def reset_password_verification_mail
    UserMailer.with(user: User.first).reset_password_verification_mail
  end
end
