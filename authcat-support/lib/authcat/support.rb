# frozen_string_literal: true

require "zeitwerk"

module Authcat
  module Support
    def self.loader
      @loader ||= Zeitwerk::Loader.for_gem_extension(Authcat)
    end

    loader.setup
  end
end
