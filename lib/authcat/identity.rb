# frozen_string_literal: true

module Authcat
  module Identity
    extend Supports::Registrable

    def self.included(base)
      base.extend ClassMethods

      base.include Token::Tokenable
      base.tokenable
    end

    module ClassMethods
      def authcat(mod_name)
        self.include Identity.lookup(mod_name)
      end
    end

    module Password
      def self.included(base)
        base.include Authcat::Password::SecurePassword,
                     Authcat::Password::Validators

        base.has_secure_password :password
        base.validates :password, presence: true, on: :create
      end

      def authenticate(password)
        password_verify(password) && self
      end
    end

    module TwoFactorAuth
      def self.included(base)
        base.include MultiFactor::TwoFactorAuth
        base.has_two_factor_auth :otp
      end
    end

    register :password, Password
    register :two_factor_auth, TwoFactorAuth
  end
end
