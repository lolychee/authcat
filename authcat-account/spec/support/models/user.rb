# frozen_string_literal: true

class User < ActiveRecord::Base
  include Authcat::Account

  # EMAIL_VALIDATE_OPTIONS = { format: URI::MailTo::EMAIL_REGEXP }.freeze
  # validates :email, presence: true, uniqueness: true, on: :save
  # validates :email, allow_nil: true, **EMAIL_VALIDATE_OPTIONS

  has_password
  has_password :one_time_password, type: :one_time_password

  has_password :recovery_codes, type: :one_time_password, algorithm: :bcrypt, array: true

  has_identifier :email, type: :email
  validates :email, identify: true, on: :email_sign_in

  has_identifier :phone_number, type: :phone_number
  validates :phone_number, identify: true, on: :phone_number_sign_in
end
