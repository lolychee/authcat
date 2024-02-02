# frozen_string_literal: true

module Authcat
  module Passkey
    module Reflections
      class HasMany < Authcat::Credential::Reflections::HasMany
        def relation_options
          @relation_options.merge(extend: Extension)
        end

        def identifiable?
          false
        end

        def identify(credential)
          credential = JSON.parse(credential) if credential.is_a?(String)
          case credential
          when Hash
            owner.includes(name).find_by(name => { name:, webauthn_id: credential["id"] }).tap do |r|
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
          return
          inverse_of_name = owner.reflect_on_association(name).send(:inverse_name)

          owner.class_eval <<-RUBY, __FILE__, __LINE__ + 1
            # frozen_string_literal: true

            def #{name}=(value)
              case value
              when String
                build_#{name}(#{inverse_of_name}: self, token: value)
              end
            end
          RUBY
        end

        module Extension
          def options_for_create(_options = {})
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
            credential = ::WebAuthn::Credential.from_get(credential)

            record = find_by(webauthn_id: credential.id)
            binding.irb
            record&.verify(credential:)
          end
        end
      end
    end
  end
end
