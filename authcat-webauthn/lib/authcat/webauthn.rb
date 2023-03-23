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

begin
  require "rails/railtie"
rescue LoadError
else
  require "authcat/webauthn/railtie"
end

module Authcat
  module WebAuthn
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def has_many_webauthn_credentials(**opts)
        attribute :webauthn_user_id, default: -> { ::WebAuthn.generate_user_id }
        has_many :webauthn_credentials, class_name: "#{name}WebAuthnCredential", extend: Extension, **opts

        define_method(:verify_webauthn_credential) do |credential|
          webauthn_credentials.verify(credential)
        end
      end
    end

    module Extension
      def options_for_create
        identity = @association.owner
        user_info = {
          id: identity.webauthn_user_id,
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
          credential = ::WebAuthn::Credential.from_get(credential)
          record.verify(credential: credential)
        else
          false
        end
      end
    end
  end
end
