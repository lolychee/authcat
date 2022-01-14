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
      gem "authcat-identifier"
      gem "authcat-password"
      gem "authcat-multi_factor"

      require "authcat/identifier"
      require "authcat/password"
      require "authcat/multi_factor"

      base.include Authcat::Identifier,
                   Authcat::Password::HasPassword,
                   Authcat::MultiFactor
    end
  end
end
