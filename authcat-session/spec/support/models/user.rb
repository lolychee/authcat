# frozen_string_literal: true

require "authcat/identifier"

class User < ActiveRecord::Base
  include Authcat::Identifier
  include Authcat::Session

  EMAIL_VALIDATE_OPTIONS = { format: URI::MailTo::EMAIL_REGEXP }.freeze
  validates :email, presence: true, uniqueness: true, on: :save
  validates :email, allow_nil: true, **EMAIL_VALIDATE_OPTIONS

  has_many_sessions class_name: "UserSession", inverse_of: :user
end
