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

    module Authenticate
      def self.included(base)
        base.include Password::SecurePassword,
                     Password::Validators

        base.has_secure_password :password
        base.validates :password, presence: true, on: :create
      end

      def authenticate(password)
        password_verify(password) && self
      end
    end

    module TwoFactorAuth
      def self.included(base)
        base.include MultiFactor::OneTimePassword
        base.include MultiFactor::BackupCodes

        base.has_one_time_password :otp
        base.has_backup_codes :otp_backup_codes
      end

      def authenticate(password, allow_backup_code: false)
        super(password) || (allow_backup_code && otp_backup_codes_verify(password, revoke: true) && self)
      end
    end

    register :authenticate, Authenticate
    register :two_factor_auth, TwoFactorAuth
  end
end
