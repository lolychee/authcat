# frozen_string_literal: true

require "active_support"
require "authcat"
require "zeitwerk"
require "webauthn"

Zeitwerk::Loader.for_gem_extension(Authcat).tap do |loader|
  loader.inflector.inflect(
    "webauthn" => "WebAuthn"
  )
  loader.setup
end

begin
  require "rails/railtie"
rescue LoadError
else
  require "authcat/passkey/railtie"
end

module Authcat
  module Passkey
    def self.included(base)
      base.include Marcos
    end
  end
end
