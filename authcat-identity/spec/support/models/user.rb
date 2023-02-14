# frozen_string_literal: true

class User < ActiveRecord::Base
  include Authcat::Identity

  has_many :sessions

  # EMAIL_VALIDATE_OPTIONS = { format: URI::MailTo::EMAIL_REGEXP }.freeze
  # validates :email, presence: true, uniqueness: true, on: :save
  # validates :email, allow_nil: true, **EMAIL_VALIDATE_OPTIONS

  # has_password :one_time_password, as: :one_time_password

  # serialize :recovery_codes_digest, Array if connection.adapter_name == 'SQLite'
  # has_recovery_codes

  ENV["LOCKBOX_MASTER_KEY"] = "0000000000000000000000000000000000000000000000000000000000000000"

  identifier :email, as: :email
  validates :email, identify: true, on: :email_sign_in

  identifier :phone_number, as: :phone_number
  validates :phone_number, identify: true, on: :phone_number_sign_in
end
