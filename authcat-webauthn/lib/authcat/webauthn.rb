# frozen_string_literal: true

require "zeitwerk"
require "webauthn"

loader = Zeitwerk::Loader.new
loader.tag = File.basename(__FILE__, ".rb")
loader.inflector = Zeitwerk::GemInflector.new(__FILE__)
loader.inflector.inflect(
  "webauthn" => "WebAuthn"
)
loader.push_dir("#{__dir__}/..")
loader.setup

module Authcat
  module WebAuthn
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def has_many_webauthn_credentials
        attribute :webauthn_user_id, default: -> { ::WebAuthn.generate_user_id }
        has_many :webauthn_credentials, class_name: "::Authcat::WebAuthn::Credential", as: :identity do
          def options_for_create
            identity = @association.owner
            user_info = {
              id: identity.webauthn_user_id,
              name: identity.name
            }
            options = ::WebAuthn::Credential.options_for_create(
              user: user_info,
              exclude: identity.webauthn_credential_ids
            )
            options.extend ChallengeSaver.new(identity, :webauthn_challenge)
            options
          end

          def options_for_get
            identity = @association.owner
            options = ::WebAuthn::Credential.options_for_get(allow: identity.webauthn_credential_ids)
            options.extend ChallengeSaver.new(identity, :webauthn_challenge)
            options
          end
        end
      end
    end

    class ChallengeSaver < Module
      def initialize(identity, column_name)
        define_method(:challenge) do
          super().tap do |challenge|
            identity.update(column_name => challenge)
          end
        end
      end
    end
  end
end
