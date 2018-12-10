# frozen_string_literal: true

class User < ApplicationRecord
  include Authcat::Identity

  authcat :identifier
  authcat :password_auth
  authcat :two_factor_auth

  EMAIL_REGEX = /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

  identifier :id, format: /^\d+$/
  identifier :email, format: EMAIL_REGEX

  validates :email, presence: true, uniqueness: true, on: :save
  validates :email, format: EMAIL_REGEX, allow_nil: true

  validates :password, length: { minimum: 6, maximum: 72 }, allow_nil: true

  concerning :SignIn do
    included do |base|
      base.define_callbacks :sign_in
      base.attribute :identifier, :string
      base.attribute :remember_me, :boolean

      base.validates :identifier, presence: true, found: true, on: :sign_in
      base.validates :password, presence: true, password_verify: { was: true }, on: :sign_in
    end

    def sign_in(attributes = {})
      self.attributes = attributes
      valid?(:sign_in) &&
      run_callbacks(:sign_in) do
        # touch!(:last_sign_in_at)
        true
      end
    end
  end

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
