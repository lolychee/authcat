# frozen_string_literal: true

module Authcat
  module MultiFactor
    module WebAuthn
      # @return [void]
      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        def has_webauthn(attribute = :webauthn, column: "#{attribute}_id", public_key_column: "#{attribute}_public_key", sign_count_column: "#{attribute}_sign_count", **opts, &block)
          gem "webauthn"
          require "webauthn"

          include InstanceMethodsOnActivation.new(attribute, column,
                                                  public_key_column: public_key_column, sign_count_column: sign_count_column, **opts, &block)
          column.to_sym
        end
      end

      class InstanceMethodsOnActivation < Module
        def initialize(attribute, column, public_key_column:, sign_count_column:, options_for_create: nil, options_for_get: nil)
          attr_accessor "#{attribute}_options", "#{attribute}_challenge"

          define_method("generate_#{attribute}_options") do |**opts|
            id = send(column)

            options = if id.nil?
                        opts.reverse_merge!(if options_for_create.respond_to?(:call)
                                              options_for_create.call
                                            else
                                              {
                                                user: { id: id, name: nil },
                                                exclude: []
                                              }
                                            end)

                        ::WebAuthn::Credential.options_for_create(opts)
                      else
                        opts.reverse_merge!(if options_for_get.respond_to?(:call)
                                              options_for_get.call
                                            else
                                              {
                                                allow: [id]
                                              }
                                            end)

                        ::WebAuthn::Credential.options_for_get(opts)
                      end
            send("#{attribute}_challenge=", options.challenge)
            send("#{attribute}_options=", options)
          end

          define_method("verify_#{attribute}") do |public_key_credential, challenge: send("#{attribute}_challenge"), raise_error: false|
            id = send(column)

            if id.nil?
              credential = ::WebAuthn::Credential.from_create(public_key_credential)
              credential.verify(challenge)

              update_columns(column => credential.id, public_key_column => credential.public_key,
                             sign_count_column => credential.sign_count)
            else
              credential = ::WebAuthn::Credential.from_get(public_key_credential)
              credential.verify(
                challenge,
                public_key: send(public_key_column),
                sign_count: send(sign_count_column)
              )

              update_columns(sign_count_column => credential.sign_count)
            end

            true
          rescue ::WebAuthn::Error => e
            raise e unless raise_error

            false
          end
        end
      end
    end
  end
end
