# frozen_string_literal: true

class User < ActiveRecord::Base
  include Authcat::Account

  # EMAIL_REGEX = /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i.freeze
  # EMAIL_VALIDATE_OPTIONS = { format: EMAIL_REGEX }.freeze
  # validates :email, presence: true, uniqueness: true, on: :save
  # validates :email, allow_nil: true, **EMAIL_VALIDATE_OPTIONS

  has_password
  has_password :one_time_password, as: :one_time_password

  has_password :recovery_codes, as: :one_time_password, array: true, algorithm: :bcrypt

  ENV["LOCKBOX_MASTER_KEY"] = "0000000000000000000000000000000000000000000000000000000000000000"

  identifier :email, as: :email
  validates :email, identify: true, on: :email_sign_in

  identifier :phone_number, as: :phone_number
  validates :phone_number, identify: true, on: :phone_number_sign_in
end
