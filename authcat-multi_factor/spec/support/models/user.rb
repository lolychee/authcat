# frozen_string_literal: true

class User < ActiveRecord::Base
  include Authcat::MultiFactor::HasOneTimePassword
  include Authcat::MultiFactor::HasBackupCodes
  include Authcat::MultiFactor::HasSecurityQuestions
  include Authcat::MultiFactor::HasWebAuthn

  EMAIL_REGEX = /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i.freeze
  EMAIL_VALIDATE_OPTIONS = { format: EMAIL_REGEX }.freeze
  validates :email, presence: true, uniqueness: true, on: :save
  validates :email, allow_nil: true, **EMAIL_VALIDATE_OPTIONS

  has_one_time_password

  serialize :backup_codes_digest, Array if connection.adapter_name == 'SQLite'
  has_backup_codes

  has_webauthn
end
