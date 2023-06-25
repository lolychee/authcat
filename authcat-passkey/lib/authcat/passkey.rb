# frozen_string_literal: true

require "active_support"
require "authcat"
require "zeitwerk"
require "webauthn"

loader = Zeitwerk::Loader.for_gem_extension(Authcat)
loader.inflector.inflect(
  "webauthn" => "WebAuthn"
)
loader.setup

begin
  require "rails/railtie"
rescue LoadError
else
  require "authcat/passkey/railtie"
end

module Authcat
  module Passkey
    extend ActiveSupport::Concern

    include Marcos
  end
end
