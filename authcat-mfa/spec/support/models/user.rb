# frozen_string_literal: true

class User < ActiveRecord::Base
  include Authcat::MFA

  EMAIL_REGEX = /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i.freeze
  EMAIL_VALIDATE_OPTIONS = { format: EMAIL_REGEX }.freeze
  validates :email, presence: true, uniqueness: true, on: :save
  validates :email, allow_nil: true, **EMAIL_VALIDATE_OPTIONS

  has_one_time_password

  has_one_time_password :recovery_code, algorithm: :bcrypt
  has_one_time_password :recovery_codes, array: true, algorithm: :bcrypt
end
