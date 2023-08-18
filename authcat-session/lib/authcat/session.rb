# frozen_string_literal: true

require "active_support"

require "authcat"
require "zeitwerk"

loader = Zeitwerk::Loader.for_gem_extension(Authcat)
loader.setup

begin
  require "rails/railtie"
rescue LoadError
else
  require "authcat/session/railtie"
end

module Authcat
  module Session
    def self.included(base)
      base.include Marcos
    end
  end
end
