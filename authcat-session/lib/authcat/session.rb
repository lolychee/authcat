# frozen_string_literal: true

require "active_support"

require "zeitwerk"

begin
  require "rails/railtie"
rescue LoadError
else
  require "authcat/session/railtie"
end

module Authcat
  module Session
    def self.loader
      @loader ||= Zeitwerk::Loader.for_gem_extension(Authcat)
    end

    loader.setup

    def self.included(base)
      base.include Marcos
    end
  end
end
