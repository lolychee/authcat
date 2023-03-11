# frozen_string_literal: true

class User < ActiveRecord::Base
  include Authcat::WebAuthn

  EMAIL_REGEX = /\A([\w+-].?)+@[a-z\d-]+(\.[a-z]+)*\.[a-z]+\z/i.freeze
  EMAIL_VALIDATE_OPTIONS = { format: EMAIL_REGEX }.freeze
  validates :email, presence: true, uniqueness: true, on: :save
  validates :email, allow_nil: true, **EMAIL_VALIDATE_OPTIONS

  has_many_webauthn_credentials
end
