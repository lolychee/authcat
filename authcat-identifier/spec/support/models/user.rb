# frozen_string_literal: true

class User < ActiveRecord::Base
  include Authcat::Identifier

  # EMAIL_VALIDATE_OPTIONS = { format: URI::MailTo::EMAIL_REGEXP }.freeze
  # validates :email, presence: true, uniqueness: true, on: :save
  # validates :email, allow_nil: true, **EMAIL_VALIDATE_OPTIONS

  # has_password :one_time_password, type: :one_time_password

  # has_recovery_codes

  # has_identifier :email, type: :email
  # has_identifier :token
  # validates :email, identify: true

  # has_identifier :phone_number, type: :phone_number, country: "CN"
  # validates :phone_number, identify: true

  # has_one_identifier :public_email, class_name: "Email", inverse_of: :user,
  #                                   identify: { identifier: :identifier }
  # has_many_identifiers :emails, identify: { identifier: :identifier }
end
