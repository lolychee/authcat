# frozen_string_literal: true

class User < ApplicationRecord
  include Authcat::Model

  attr_accessor :password_confirmation
  has_secure_password

  EMAIL_REGEX = /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

  PASSWORD_VALIDATES_OPTIONS = { length: { minimum: 6, maximum: 72 } }

  with_options on: :save do
    validates :email, presence: true, uniqueness: true, format: { with: EMAIL_REGEX }
    validates :password_digest, presence: true
  end

  with_options on: :create do
    validates :password, presence: true, **PASSWORD_VALIDATES_OPTIONS
  end

  class << self
    def find_by_identifier(identifier)
      case identifier
      when EMAIL_REGEX
        find_by(email: identifier.downcase)
      # when /\d+/
      #   find(identifier)
      else
        nil
      end
    end
  end

  concerning :ResetPassword do
    included do
      attr_accessor :current_password, :skip_current_password
      with_options on: :reset_password do
        validates :current_password, password_verify: :password_digest_was, unless: :skip_current_password
        validates :password, presence: true, confirmation: true, **PASSWORD_VALIDATES_OPTIONS
      end
    end

    def reset_password(attributes = {})
      self.attributes = attributes
      valid?(:reset_password) && save
    end
  end
end
