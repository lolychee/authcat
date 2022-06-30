# frozen_string_literal: true

require "zeitwerk"
loader = Zeitwerk::Loader.new
loader.tag = File.basename(__FILE__, ".rb")
loader.inflector = Zeitwerk::GemInflector.new(__FILE__)
loader.push_dir("#{__dir__}/..")
loader.setup

module Authcat
  module Account
    def self.included(base)
      gem "authcat-identity"
      gem "authcat-password"
      gem "authcat-mfa"

      require "authcat/identity"
      require "authcat/password"
      require "authcat/mfa"

      base.include Authcat::Identity,
                   Authcat::Password,
                   Authcat::MFA
    end
  end
end
