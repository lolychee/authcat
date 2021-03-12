# frozen_string_literal: true

class User < ActiveRecord::Base
  include Authcat::Password::HasPassword

  EMAIL_REGEX = /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i.freeze
  EMAIL_VALIDATE_OPTIONS = { format: EMAIL_REGEX }.freeze
  validates :email, presence: true, uniqueness: true, on: :save
  validates :email, allow_nil: true, **EMAIL_VALIDATE_OPTIONS

  has_password
  # serialize :password_digest, Array if connection.adapter_name == "SQLite"
  PASSWORD_VALIDATE_OPTIONS = { length: { minimum: 6, maximum: 72 } }.freeze
  validates :password, allow_nil: true, **PASSWORD_VALIDATE_OPTIONS

  validates :password, authenticate: true, on: :sign_in

  # concerning :SendResetPasswordVerification do
  #   included do |base|
  #     base.define_callbacks :send_reset_password_verification
  #     # base.validates :identifier, identification: true, on: :send_reset_password_verification
  #   end

  #   def send_reset_password_verification
  #     valid?(:send_reset_password_verification) &&
  #     run_callbacks(:send_reset_password_verification) do
  #       UserMailer.with(user: self).reset_password_verification_mail.deliver_later
  #     end
  #   end
  # end
end
