# frozen_string_literal: true

require "zeitwerk"
loader = Zeitwerk::Loader.new
loader.tag = File.basename(__FILE__, ".rb")
loader.inflector = Zeitwerk::GemInflector.new(__FILE__)
loader.inflector.inflect(
  "kdf" => "KDF",
  "bcrypt" => "BCrypt",
)

loader.push_dir("#{__dir__}/..")
loader.setup

module Authcat
  module Password
    class << self
      # @return [Symbol, String, self]
      attr_accessor :default_kdf
    end

    self.default_kdf = :bcrypt

    def self.included(base)
      base.class.attr_accessor :password_attributes
      base.extend ClassMethods
      base.include Validators,
                   SecurePassword
    end

    module ClassMethods
      def _password_singleton_module # :nodoc:
        @_password_singleton_module ||= begin
          mod = Module.new
          extend mod
          mod
        end
      end

      def _password_instance_module # :nodoc:
        @_password_instance_module ||= begin
          mod = Module.new
          extend mod
          mod
        end
      end
    end
  end
end
