# frozen_string_literal: true

class User < ActiveRecord::Base
  include Authcat::Credential

  # EMAIL_VALIDATE_OPTIONS = { format: URI::MailTo::EMAIL_REGEXP }.freeze
  # validates :email, presence: true, uniqueness: true, on: :save
  # validates :email, allow_nil: true, **EMAIL_VALIDATE_OPTIONS

  # validates :email, identify: true, on: :email_sign_in

  # validates :phone_number, identify: true
end
