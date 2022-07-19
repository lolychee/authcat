# frozen_string_literal: true

require "zeitwerk"
require "authcat/password"

loader = Zeitwerk::Loader.new
loader.tag = File.basename(__FILE__, ".rb")
loader.inflector = Zeitwerk::GemInflector.new(__FILE__)
loader.inflector.inflect(
  "mfa" => "MFA",
  "webauthn" => "WebAuthn",
  "totp" => "TOTP",
  "hotp" => "HOTP"
)
loader.push_dir("#{__dir__}/..")
loader.setup

module Authcat
  module MFA
    # @return [void]
    def self.included(base)
      base.include OneTimePassword,
                   RecoveryCodes,
                   WebAuthn
    end

    Password::Engines.register(:totp) { Engines::TOTP }
  end
end
