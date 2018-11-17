# frozen_string_literal: true

module Authcat
  module Identity
    extend Supports::Registrable

    def self.included(base)
      base.include Authcat::Model

      base.tokenable
      base.include Password
      base.include TwoFactorAuthentication
    end

    module Password
      def self.included(base)
        base.has_secure_password

        base.validates :password, presence: true, on: :create
      end

      def authenticate(password)
        password_verify(password) && self
      end
    end

    module TwoFactorAuthentication
      def self.included(base)
        base.has_one_time_password :otp
        base.has_backup_codes :otp_backup_codes
      end

      def two_factor_authentication_required?
        !!otp
      end

      def authenticate(password, allow_backup_code: false)
        super(password) && (allow_backup_code && otp_backup_codes_verify(password, revoke: true) && self)
      end
    end
  end
end
