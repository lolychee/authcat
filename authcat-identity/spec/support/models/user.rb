# frozen_string_literal: true

class User < ActiveRecord::Base
  include Authcat::Identity

  has_many :sessions

  # EMAIL_VALIDATE_OPTIONS = { format: URI::MailTo::EMAIL_REGEXP }.freeze
  # validates :email, presence: true, uniqueness: true, on: :save
  # validates :email, allow_nil: true, **EMAIL_VALIDATE_OPTIONS

  # has_password :one_time_password, as: :one_time_password

  # has_recovery_codes

  identifier :email, as: :email
  # validates :email, identify: true

  identifier :phone_number, as: :phone_number, country: "CN"
  # validates :phone_number, identify: true

  has_one_identifier :public_email, as: :email
  has_many_identifiers :emails, as: :email
end
