# frozen_string_literal: true

require "authcat"
require "zeitwerk"

loader = Zeitwerk::Loader.for_gem_extension(Authcat)
loader.setup

module Authcat
  module Account
    def self.included(base)
      gem "authcat-identifier"
      gem "authcat-password"

      require "authcat/identifier"
      require "authcat/password"

      base.include Authcat::Identifier,
                   Authcat::Password
    end
  end
end
