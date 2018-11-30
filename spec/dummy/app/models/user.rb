# frozen_string_literal: true

class User < ApplicationRecord
  include Authcat::Identity

  authcat :password_auth
  authcat :two_factor_auth

  EMAIL_REGEX = /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

  concerning :Identifier do
    included do
      validates :email, presence: true, uniqueness: true, format: { with: EMAIL_REGEX }
      before_save { |user| user.email.try(:downcase!) }
    end

    class_methods do
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
  end

  validates :password, length: { minimum: 6, maximum: 72 }, allow_nil: true
end
