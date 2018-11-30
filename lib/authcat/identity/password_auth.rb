# frozen_string_literal: true

module Authcat
  module Identity
    module PasswordAuth
      def self.setup(base)
        base.include self

        base.has_secure_password :password
        base.validates :password, presence: true, on: :create
      end

      def self.included(base)
        base.include Password::SecurePassword,
                     Password::Validators
      end

      def authenticate(password)
        password_verify(password) && self
      end
    end
  end
end
