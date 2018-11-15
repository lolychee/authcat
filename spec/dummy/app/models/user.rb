# frozen_string_literal: true

class User < ApplicationRecord
  include Authcat::Identity

  EMAIL_REGEX = /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

  concerning :Identifier do
    included do
      validates :email, presence: true, uniqueness: true, format: { with: EMAIL_REGEX }
      before_save { |user| user.email = user.email.downcase if user.email }
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

  concerning :ResetPassword do
    included do
      attr_accessor :current_password, :skip_current_password

      with_options on: :reset_password do
        validates :current_password, password_verify: :password_digest_was, unless: :skip_current_password
        validates :password, presence: true, confirmation: true
      end
    end

    def reset_password(attributes = {})
      self.attributes = attributes
      valid?(:reset_password) && save
    end
  end
end
