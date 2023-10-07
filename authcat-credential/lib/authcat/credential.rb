# frozen_string_literal: true

require "active_support"
require "authcat"

require "zeitwerk"

Zeitwerk::Loader.for_gem_extension(Authcat).tap(&:setup)

module Authcat
  module Credential
    def self.included(base)
      base.include(Marcos)
    end
  end
end
