# frozen_string_literal: true

require "zeitwerk"

loader = Zeitwerk::Loader.new
loader.tag = File.basename(__FILE__, ".rb")
loader.inflector = Zeitwerk::GemInflector.new(__FILE__)
loader.push_dir("#{__dir__}/..")
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
      def has_many_sessions
        has_many :sessions, class_name: "#{name}Session"
      end
    end
  end
end
