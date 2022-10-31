# frozen_string_literal: true

module Authcat
  module WebAuthn
    class Credential < Record
      self.table_name = "authcat_webauthn_credentials"

      belongs_to :identity, polymorphic: true, touch: true

      attr_accessor :webauthn_credential

      validates :name, uniqueness: { scope: %i[identity_type identity_id] }
      validates :public_key, uniqueness: true

      define_model_callbacks :verify
      validates :webauthn_credential, presence: true, on: %i[create verify]
      validate :validate_webauthn_credential, on: %i[create verify]

      def webauthn_credential=(credential)
        if credential.is_a?(Hash)
          if new_record?
            credential = ::WebAuthn::Credential.from_create(credential)
            assign_attributes(
              webauthn_id: credential.id,
              public_key: credential.public_key,
              sign_count: credential.sign_count
            )
          else
            credential = ::WebAuthn::Credential.from_get(credential)
          end
        end
        @webauthn_credential = credential
      end

      def verify(attributes = {})
        assign_attributes(attributes)
        valid?(:verify) && run_callbacks(:verify) do
          identity.update(webauthn_challenge: nil)
          update(sign_count: webauthn_credential.sign_count)
        end
      end

      private

      def validate_webauthn_credential
        verified = webauthn_credential.verify(
          identity.webauthn_challenge,
          **(new_record? ? {} : { public_key: public_key, sign_count: sign_count })
        )

        errors.add(:webauthn_credential, "is invalid") unless verified
      end
    end
  end
end
