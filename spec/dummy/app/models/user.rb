# frozen_string_literal: true

class User < ApplicationRecord
  include Authcat::Model

  attr_accessor :password_confirmation
  has_secure_password

  EMAIL_REGEX = /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

  with_options on: :save do
    validates :email, presence: true, uniqueness: true, format: { with: EMAIL_REGEX }
    validates :password_digest, presence: true
  end

  with_options on: :create do
    validates :password, presence: true, confirmation: true, length: { minimum: 6, maximum: 72 }
  end

  class << self
    def find_by_identifier(identifier)
      case identifier
      when EMAIL_REGEX
        find_by(email: identifier.downcase)
      when /\d+/
        find(identifier)
      else
        nil
      end
    end
  end
end
