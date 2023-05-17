# frozen_string_literal: true

require "authcat"
require "zeitwerk"
loader = Zeitwerk::Loader.for_gem_extension(Authcat)
loader.inflector.inflect(
  "bcrypt" => "BCrypt",
  "totp" => "TOTP",
  "hotp" => "HOTP"
)
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
      # @param attribute [Symbol, String]
      # @param as [Symbol]
      # @return [Symbol]
      def has_password(attribute = :password, as: :digest, **opts, &block)
        Attribute.resolve(as).new(self, attribute, **opts, &block).setup!

        attribute.to_sym
      end
    end
  end
end
