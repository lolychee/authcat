# frozen_string_literal: true

class User < ActiveRecord::Base
  include Authcat::Password

  EMAIL_VALIDATE_OPTIONS = { format: URI::MailTo::EMAIL_REGEXP }.freeze
  validates :email, presence: true, uniqueness: true, on: :save
  validates :email, allow_nil: true, **EMAIL_VALIDATE_OPTIONS

  has_password
  PASSWORD_VALIDATE_OPTIONS = { length: { minimum: 6, maximum: 72 } }.freeze
  # validates :password, allow_nil: true, **PASSWORD_VALIDATE_OPTIONS

  has_password :one_time_password, type: :one_time_password
  has_password :one_time_code, type: :one_time_password, algorithm: :bcrypt
  has_password :recovery_codes, type: :one_time_password, algorithm: :bcrypt, array: true,
                                burn_after_verify: true

  has_password :polymorphic_password, polymorphic: true

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
