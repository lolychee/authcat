# frozen_string_literal: true

require "zeitwerk"

begin
  require "rails/railtie"
rescue LoadError
else
  require "authcat/identity_provider/railtie"
end

module Authcat
  module IdentityProvider
    def self.loader
      @loader ||= Zeitwerk::Loader.for_gem_extension(Authcat)
    end

    loader.setup

    def self.included(base)
      base.include Marcos
    end
  end
end
