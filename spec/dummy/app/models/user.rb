# frozen_string_literal: true

class User < ApplicationRecord
  include Authcat::Identity

  authcat :identifier
  authcat :password_auth
  authcat :two_factor_auth

  EMAIL_REGEX = /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

  concerning :Identifier do
    included do
      identifier :id, format: /^\d+$/
      identifier :email, format: EMAIL_REGEX

      validates :email, presence: true, uniqueness: true, on: :save
      validates :email, format: EMAIL_REGEX, allow_nil: true
    end
  end

  validates :password, length: { minimum: 6, maximum: 72 }, allow_nil: true

  def send_reset_password_verification
    !errors.any? && UserMailer.with(user: self).reset_password_verification_mail.deliver_later
  end
end
