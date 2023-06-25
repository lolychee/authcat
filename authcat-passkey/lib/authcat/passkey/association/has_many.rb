# frozen_string_literal: true

module Authcat
  module Passkey
    module Association
      class HasMany < Authcat::Credential::Association::HasMany
        def relation_options
          @relation_options.merge(extend: Extension)
        end

        def identify(credential)
          credential = JSON.parse(credential) if credential.is_a?(String)
          case credential
          when Hash
            owner.includes(name).find_by(name => { name: name, webauthn_id: credential["id"] }).tap do |r|
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

        def setup_instance_methods!
          owner.class_eval <<-CODE, __FILE__, __LINE__ + 1
            # frozen_string_literal: true

            def #{name}=(value)
              case value
              when String
                build_#{name}(#{relation_options[:inverse_of]}: self, token: value)
              end
            end
          CODE
        end

        module Extension
          def options_for_create
            identity = @association.owner
            user_info = {
              id: identity.webauthn_id,
              name: identity.name
            }
            ::WebAuthn::Credential.options_for_create(
              user: user_info,
              exclude: pluck(:webauthn_id)
            ).tap { |options| identity.update_columns(webauthn_challenge: options.challenge) }
          end

          def options_for_get
            identity = @association.owner
            ::WebAuthn::Credential.options_for_get(allow: pluck(:webauthn_id)).tap do |options|
              identity.update_columns(webauthn_challenge: options.challenge)
            end
          end

          def verify(credential)
            credential = JSON.parse(credential) if credential.is_a?(String)
            case credential
            when Hash
              record = find(credential["id"])
              record.verify(credential: ::WebAuthn::Credential.from_get(credential))
            else
              false
            end
          end
        end
      end
    end
  end
end
