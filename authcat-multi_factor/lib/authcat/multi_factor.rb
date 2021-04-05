# frozen_string_literal: true

require 'zeitwerk'
loader = Zeitwerk::Loader.new
loader.tag = File.basename(__FILE__, '.rb')
loader.inflector = Zeitwerk::GemInflector.new(__FILE__)
loader.inflector.inflect(
  'has_webauthn' => 'HasWebAuthn'
)
loader.push_dir("#{__dir__}/..")
loader.setup

module Authcat
  module MultiFactor
    # @return [void]
    def self.included(base)
      gem 'authcat-password'
      require 'authcat/password'

      base.include \
        Authcat::Password::HasPassword,
        Authcat::Password::Validators,
        HasOneTimePassword,
        HasBackupCodes,
        HasWebAuthn
    end
  end
end
