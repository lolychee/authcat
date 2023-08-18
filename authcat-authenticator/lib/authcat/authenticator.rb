# frozen_string_literal: true

require "authcat"
require "zeitwerk"

loader = Zeitwerk::Loader.for_gem_extension(Authcat)
loader.setup

module Authcat
  module Authenticator
    def self.included(base)
      base.include Marcos, Validators
    end
  end
end
