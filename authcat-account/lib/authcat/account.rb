# frozen_string_literal: true

require "authcat"
require "zeitwerk"

loader = Zeitwerk::Loader.for_gem_extension(Authcat)
loader.setup

module Authcat
  module Account
    def self.included(base)
      gem "authcat-identity"
      gem "authcat-password"

      require "authcat/identity"
      require "authcat/password"

      base.include Authcat::Identity,
                   Authcat::Password
    end
  end
end
