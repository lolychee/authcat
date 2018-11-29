# frozen_string_literal: true

module Authcat
  module MultiFactor
    module TwoFactorAuth
      def self.included(base)
        base.include OneTimePassword
        base.include BackupCodes

        base.extend ClassMethods
      end

      module ClassMethods
        def has_two_factor_auth(attribute = :tfa)
          self.has_one_time_password attribute
          self.has_backup_codes "#{attribute}_backup_codes"

          mod = Module.new

          mod.class_eval <<-RUBY

            def authenticate(password, allow_backup_code: false)
              super(password) || (allow_backup_code && #{attribute}_backup_codes_verify(password, revoke: true) && self)
            end
          RUBY

          self.include mod
        end
      end
    end
  end
end
