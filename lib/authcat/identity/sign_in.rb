module Authcat
  module Identity
    module SignIn
      def self.setup(base, identifier: :identifier, password_auth: true, two_factor_auth: false)
        base.include self

        base.define_callbacks :sign_in

        base.attribute identifier, :string
        base.validates identifier, presence: true, found: true, if: :new_record?, on: :sign_in

        base.include SignIn::PasswordAuth if password_auth
        base.include SignIn::TwoFactorAuth if two_factor_auth
      end

      def sign_in(via: :password)
        # self.attributes = attributes
        contexts = Array(via).map {|auth_type| "sign_in_via_#{auth_type}" }
        valid?([:sign_in] + contexts) &&
        run_callbacks(:sign_in) do
          touch(:last_sign_in_at)
        end
      end

      module PasswordAuth
        def self.included(base)
          base.validates :password, presence: true, password_verify: { was: true }, on: :sign_in_via_password
        end
      end

      module TwoFactorAuth
        def self.included(base)
          base.validates :tfa_code, presence: true, on: :sign_in_via_tfa_code
        end
      end
    end
  end
end
