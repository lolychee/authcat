# frozen_string_literal: true

module Authcat
  module Passkey
    module Reflections
      class HasMany < Authcat::Credential::Reflections::HasMany
        def relation_options
          @relation_options.merge(extend: Extension)
        end

        def identify(credential)
          credential = JSON.parse(credential) if credential.is_a?(String)
          case credential
          when Hash
            owner.includes(name).find_by(name => { webauthn_id: credential["id"] }).tap do |r|
              return nil unless r && r.send(name).first.verify(credential: ::WebAuthn::Credential.from_get(credential))
            end
          end
        end

        def setup!
          setup_attribute!
          super
        end

        def setup_attribute!
          owner.attribute :webauthn_id, default: -> { ::WebAuthn.generate_user_id }
        end

        module Extension
          def options_for_create(options = {})
            identity = @association.owner
            user_info = {
              id: identity.webauthn_id,
              name: identity.name
            }
            ::WebAuthn::Credential.options_for_create(
              user: user_info,
              exclude: pluck(:webauthn_id),
              **options
            ).tap do |opts|
              unsigned.delete_all
              unsigned.find_or_create_by!(challenge: opts.challenge)
            end
          end

          def options_for_get(options = {})
            passkeys = signed.all
            ::WebAuthn::Credential.options_for_get(
              allow: passkeys.map(&:webauthn_id),
              **options
            ).tap do |opts|
              passkeys.update_all(challenge: opts.challenge)
            end
          end

          def verify(credential)
            credential = JSON.parse(credential) if credential.is_a?(String)
            passkey = if loaded?
                        find { |r| r.webauthn_id == credential["id"] }
                      else
                        find_by(webauthn_id: credential["id"])
                      end || unsigned.take

            !passkey.nil? && passkey.verify(credential:)
          end
        end
      end
    end
  end
end
