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

    def self.included(base)
      base.include HasOneTimePassword
      base.include HasBackupCodes
      base.include HasWebAuthn
    end
  end
end
