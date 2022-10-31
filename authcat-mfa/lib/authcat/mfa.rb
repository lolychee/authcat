# frozen_string_literal: true

require "zeitwerk"
require "authcat/password"
require "authcat/webauthn"

loader = Zeitwerk::Loader.new
loader.tag = File.basename(__FILE__, ".rb")
loader.inflector = Zeitwerk::GemInflector.new(__FILE__)
loader.inflector.inflect(
  "mfa" => "MFA",
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
                   Authcat::WebAuthn
    end

    Password::Algorithms.register(:totp) { Algorithms::TOTP }
  end
end
