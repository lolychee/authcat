# frozen_string_literal: true

require "active_support"
require "authcat"
require "zeitwerk"

loader = Zeitwerk::Loader.for_gem_extension(Authcat)
loader.setup

module Authcat
  module Credential
    def self.included(base)
      base.include(Marcos)
    end
  end
end
