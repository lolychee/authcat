module Authcat
  module Identity
    module SignIn
      def self.setup(base, identifier: :identifier, password_auth: true, two_factor_auth: false)
        base.include self

        base.define_callbacks :sign_in

        base.attribute identifier, :string unless base.attribute_names.include?(identifier.to_s)
        base.validates identifier, presence: true, found: true, if: :new_record?, on: :sign_in

        base.include SignIn::PasswordAuth if password_auth
        base.include SignIn::TwoFactorAuth if two_factor_auth
      end

      def sign_in(via: :password)
        valid?(:sign_in) && Array(via).all? {|auth_type| valid?(:"sign_in_via_#{auth_type}") } &&
        run_callbacks(:sign_in) do
          touch(:last_sign_in_at)
        end
      end

      module PasswordAuth
        def self.included(base)
          base.validates :password, presence: true, on: :sign_in_via_password
          base.validate(on: :sign_in_via_password) do
            errors.add(:password, "is not match") unless authenticate(password)
          end
        end

        def authenticate(password)
          password_verify(password, was: true) && self
        end
      end

      module TwoFactorAuth
        def self.included(base)
          base.attr_accessor :tfa_verify_skiped
          base.validates :tfa_code, presence: true, on: :sign_in_via_tfa_code
          base.validate on: :sign_in_via_tfa_code do
            validate_tfa_code
          end
        end

        def authenticate(password, allow_backup_code: true)
          super(password) || (allow_backup_code && tfa_backup_codes_verify(password, revoke: true) && (self.tfa_verify_skiped = true) && self)
        end

        def tfa_verify_needed?
          tfa_enabled? && !tfa_verify_skiped
        end
      end
    end
  end
end
