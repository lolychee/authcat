# frozen_string_literal: true

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
      base.extend ClassMethods
    end

    module ClassMethods
      def has_many_sessions(**opts, &block)
        has_many :sessions, class_name: "#{name}Session", **opts, &block
      end
    end
  end
end
