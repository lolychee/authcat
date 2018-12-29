# frozen_string_literal: true

class User < ApplicationRecord
  include Authcat::Identity

  authcat :identifier
  authcat :password_auth
  authcat :two_factor_auth
  authcat :sign_in, two_factor_auth: true

  REMEMBER_ME_DURATION = 60.days
  attribute :remember_me, :boolean

  EMAIL_REGEX = /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

  identifier :id, format: /^\d+$/
  identifier :email, format: EMAIL_REGEX

  validates :email, presence: true, uniqueness: true, on: :save
  validates :email, format: EMAIL_REGEX, allow_nil: true

  validates :password, length: { minimum: 6, maximum: 72 }, allow_nil: true

  concerning :ResetPassword do
    included do |base|
      base.define_callbacks :send_reset_password_verification
      base.validates :identifier, found: true, on: :send_reset_password_verification
    end

    def send_reset_password_verification(attributes = {})
      self.attributes = attributes
      valid?(:send_reset_password_verification) &&
      run_callbacks(:send_reset_password_verification) do
        UserMailer.with(user: self).reset_password_verification_mail.deliver_later
      end
    end
  end
end
