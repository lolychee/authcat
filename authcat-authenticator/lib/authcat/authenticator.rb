# frozen_string_literal: true

require "authcat"
require "zeitwerk"

Zeitwerk::Loader.for_gem_extension(Authcat).tap(&:setup)

module Authcat
  module Authenticator
    def self.included(base)
      base.include Marcos, Validators
    end
  end
end
