# frozen_string_literal: true

require "active_support"

require "zeitwerk"

module Authcat
  module Credential
    def self.loader
      @loader ||= Zeitwerk::Loader.for_gem_extension(Authcat)
    end

    loader.setup

    def self.included(base)
      base.include(Marcos)
    end
  end
end
