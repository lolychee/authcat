# frozen_string_literal: true

require "zeitwerk"
loader = Zeitwerk::Loader.new
loader.tag = File.basename(__FILE__, ".rb")
loader.inflector = Zeitwerk::GemInflector.new(__FILE__)
loader.inflector.inflect(
  "bcrypt" => "BCrypt"
)

loader.push_dir("#{__dir__}/..")
loader.collapse("#{__dir__}/password/concerns")
loader.setup

module Authcat
  module Password
    class << self
      # @return [Symbol, String, self]
      attr_accessor :default_engine

      def included(base)
        base.class.attr_accessor :password_attributes
        base.extend ClassMethods
        base.include Validators
      end

      # @param original [String]
      # @param other [String]
      # @return [Boolean]
      def secure_compare(original, other)
        original.bytesize == other.bytesize && OpenSSL.fixed_length_secure_compare(original, other)
      end
    end

    module ClassMethods
      # @param Attribute [Symbol, String]
      # @param suffix [Symbol, String]
      # @param column_name [Symbol, String]
      # @param validate [Boolean]
      # @return [Symbol]
      def has_password(attribute = :password, **opts, &block)
        Attribute.new(self, attribute, **opts, &block).setup!
      end
    end
  end
end
