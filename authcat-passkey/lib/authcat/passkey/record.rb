# frozen_string_literal: true

module Authcat
  module Passkey
    module Record
      def self.included(base)
        base.validates :webauthn_id, :public_key, uniqueness: true
        base.define_model_callbacks :verify
        base.validates :credential, presence: true, on: %i[verify]
        base.validate :validate_credential, on: %i[verify]
        base.scope :unsigned, -> { where(webauthn_id: nil, public_key: nil, sign_count: nil) }
        base.scope :signed, -> { where.not(unsigned.where_values_hash) }
      end

      def signed?
        !sign_count.nil?
      end

      attr_reader :credential

      def credential=(credential)
        credential = JSON.parse(credential) if credential.is_a?(String)
        @credential = if credential.is_a?(Hash)
                        if signed?
                          ::WebAuthn::Credential.from_get(credential)
                        else
                          ::WebAuthn::Credential.from_create(credential)
                        end
                      else
                        credential
                      end
      end

      def verify(attributes = {})
        assign_attributes(attributes)
        valid?(:verify) && run_callbacks(:verify) do
          if signed?
            update(sign_count: credential.sign_count)
          else
            update(
              webauthn_id: credential.id,
              public_key: credential.public_key,
              sign_count: credential.sign_count
            )
          end
        end
      end

      private

      def validate_credential
        verified =
          if signed?
            credential.verify(challenge, public_key:, sign_count:)
          else
            credential.verify(challenge)
          end

        errors.add(:credential, "is invalid") unless verified
      end
    end
  end
end
