# frozen_string_literal: true

module Authcat
  module WebAuthn
    module CredentialRecord
      def self.included(base)
        base.extend ClassMethods

        base.primary_key = :webauthn_id
        base.validates :name, uniqueness: { scope: :"#{base.identity_name}_id" }
        base.validates :public_key, uniqueness: true
        base.define_model_callbacks :verify
        base.validates :credential, presence: true, on: %i[create verify]
        base.validate :validate_credential, on: %i[create verify]
      end

      module ClassMethods
        def identity_name
          @identity_name ||= name.delete_suffix("WebAuthnCredential").downcase
        end
      end

      attr_accessor :challenge

      def options
        @options ||= begin
          identity = send(self.class.identity_name)
          credentials = identity.webauthn_credentials
          new_record? ? credentials.options_for_create : credentials.options_for_get
        end
      end

      attr_reader :credential

      def credential=(credential)
        return if credential.nil?

        if credential.is_a?(Hash)
          credential = if new_record?
                         ::WebAuthn::Credential.from_create(credential)
                       else
                         ::WebAuthn::Credential.from_get(credential)
                       end
        end

        if new_record?
          assign_attributes(
            webauthn_id: credential.id,
            public_key: credential.public_key,
            sign_count: credential.sign_count
          )
        end
        @credential = credential
      end

      def credential_json=(json)
        self.credential = JSON.parse(json) if json.is_a?(String)
      end

      def verify(attributes = {})
        assign_attributes(attributes)
        valid?(:verify) && run_callbacks(:verify) do
          update(sign_count: credential.sign_count)
        end
      end

      private

      def validate_credential
        return unless credential.present?

        challenge = send(self.class.identity_name).webauthn_challenge

        verified =
          if new_record?
            credential.verify(challenge)
          else
            credential.verify(challenge, public_key: public_key, sign_count: sign_count)
          end

        if verified
          send(self.class.identity_name).update_columns(webauthn_challenge: nil)
        else
          errors.add(:credential, "is invalid")
        end
      end
    end
  end
end
