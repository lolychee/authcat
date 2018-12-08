module Authcat
  module Identity
    module TwoFactorAuth
      def self.setup(base)
        base.include MultiFactor::OneTimePassword,
                     MultiFactor::BackupCodes
                     self

        base.has_one_time_password :otp
        base.has_backup_codes :otp_backup_codes
      end

      def authenticate(password, allow_backup_code: false)
        super(password) || (allow_backup_code && otp_backup_codes_verify(password, revoke: true) && self)
      end
    end
  end
end
