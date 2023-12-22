# frozen_string_literal: true

require "zeitwerk"

module Authcat
  module Account
    def self.loader
      @loader ||= Zeitwerk::Loader.for_gem_extension(Authcat)
    end

    loader.setup

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
