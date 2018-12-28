module Authcat
  module Identity
    module TwoFactorAuth
      def self.setup(base, update_tfa: true, sign_in: true)
        base.include MultiFactor::OneTimePassword,
                     MultiFactor::BackupCodes,
                     self

        base.has_one_time_password :tfa
        base.has_backup_codes :tfa_backup_codes

        base.attribute :tfa_code, :string

        base.validate :verify_tfa_code, if: :tfa_code

        base.include UpdateTFA if update_tfa
        base.include SignIn if sign_in
      end

      def authenticate(password, allow_backup_code: false)
        super(password) || (allow_backup_code && tfa_backup_codes_verify(password, revoke: true) && self)
      end

      def tfa_enabled?
        !tfa.nil? && !last_tfa_at.nil?
      end

      def verify_tfa_code
        errors.add(:tfa_code, "is not verify") unless tfa_verify(tfa_code)
      end

      module UpdateTFA
        def self.included(base)
          base.define_callbacks :update_tfa
          base.set_callback :update_tfa, :before, :generate_tfa_backup_codes, if: -> { !tfa_backup_codes && last_tfa_at }
        end

        def update_tfa(attributes = {})
          self.attributes = attributes
          valid?(:update_tfa) &&
          run_callbacks(:update_tfa) do
            save
          end
        end
      end

      module SignIn
        def self.included(base)
          base.validates :tfa_code, presence: true, if: :tfa_enabled?, on: :sign_in
        end
      end
    end
  end
end
