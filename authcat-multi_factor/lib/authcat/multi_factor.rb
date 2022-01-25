# frozen_string_literal: true

require "zeitwerk"
loader = Zeitwerk::Loader.new
loader.tag = File.basename(__FILE__, ".rb")
loader.inflector = Zeitwerk::GemInflector.new(__FILE__)
loader.inflector.inflect(
  "webauthn" => "WebAuthn",
  "totp" => "TOTP",
  "hotp" => "HOTP"
)
loader.push_dir("#{__dir__}/..")
loader.setup

module Authcat
  module MultiFactor
    # @return [void]
    def self.included(base)
      base.include OneTimePassword,
                   RecoveryCodes,
                   WebAuthn
    end
  end
end
