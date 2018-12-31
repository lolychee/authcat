module Authcat
  module Identity
    module TwoFactorAuth
      def self.setup(base, update_tfa: true)
        base.include MultiFactor::OneTimePassword,
                     MultiFactor::BackupCodes,
                     self

        base.has_one_time_password :tfa
        base.has_backup_codes :tfa_backup_codes

        base.attribute :tfa_code, :string

        base.include UpdateTFA if update_tfa
      end

      def tfa_enabled?
        !tfa.nil? && !last_tfa_at.nil?
      end

      def validate_tfa_code
        errors.add(:tfa_code, "is not verified") unless tfa_verify(tfa_code)
      end

      module UpdateTFA
        def self.included(base)
          base.define_callbacks :update_tfa
          base.set_callback(:update_tfa, :before) do
            if tfa_enabled?
              self.tfa_backup_codes_digest || self.generate_tfa_backup_codes
            else
              self.tfa_backup_codes_digest = nil
            end
          end
          base.validate if: :tfa_code, on: :update_tfa do
            validate_tfa_code
          end
        end

        def update_tfa
          valid?(:update_tfa) &&
          run_callbacks(:update_tfa) do
            save
          end
        end
      end
    end
  end
end
