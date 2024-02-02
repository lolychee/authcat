# frozen_string_literal: true

require "zeitwerk"

module Authcat
  module Authenticator
    def self.loader
      @loader ||= Zeitwerk::Loader.for_gem_extension(Authcat)
    end

    loader.setup

    def self.included(base)
      base.include Validators
    end
  end
end
