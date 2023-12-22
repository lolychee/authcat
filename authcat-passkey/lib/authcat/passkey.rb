# frozen_string_literal: true

require "active_support"
require "zeitwerk"
require "webauthn"

begin
  require "rails/railtie"
rescue LoadError
else
  require "authcat/passkey/railtie"
end

module Authcat
  module Passkey
    def self.loader
      @loader ||= Zeitwerk::Loader.for_gem_extension(Authcat)
    end

    loader.inflector.inflect(
      "webauthn" => "WebAuthn"
    )
    loader.setup

    def self.included(base)
      base.include Marcos
    end
  end
end
