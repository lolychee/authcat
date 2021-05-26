# frozen_string_literal: true

class User < ActiveRecord::Base
  include Authcat::MultiFactor::OneTimePassword
  include Authcat::MultiFactor::RecoveryCodes
  include Authcat::MultiFactor::SecurityQuestions
  include Authcat::MultiFactor::WebAuthn

  EMAIL_REGEX = /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i.freeze
  EMAIL_VALIDATE_OPTIONS = { format: EMAIL_REGEX }.freeze
  validates :email, presence: true, uniqueness: true, on: :save
  validates :email, allow_nil: true, **EMAIL_VALIDATE_OPTIONS

  has_one_time_password

  serialize :recovery_codes_digest, Array if connection.adapter_name == 'SQLite'
  has_recovery_codes

  has_webauthn
end
