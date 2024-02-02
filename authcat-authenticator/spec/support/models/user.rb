# frozen_string_literal: true

class User < ActiveRecord::Base
  include Authcat::Authenticator

  # EMAIL_VALIDATE_OPTIONS = { format: URI::MailTo::EMAIL_REGEXP }.freeze
  # validates :email, presence: true, uniqueness: true, on: :save
  # validates :email, allow_nil: true, **EMAIL_VALIDATE_OPTIONS

  has_secure_password

  # authentication_method :password
end
