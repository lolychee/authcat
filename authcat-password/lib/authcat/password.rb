# frozen_string_literal: true

require "active_support"
require "authcat"
require "zeitwerk"

Zeitwerk::Loader.for_gem_extension(Authcat).tap do |loader|
  loader.inflector.inflect(
    "bcrypt" => "BCrypt",
    "totp" => "TOTP",
    "hotp" => "HOTP"
  )
  loader.setup
end

module Authcat
  module Password
    def self.included(base)
      base.extend ClassMethods
      base.include Marcos
    end

    module ClassMethods
      def passwords
        credentials.select do |_, credential|
          case credential
          when Association::Attribute, Association::HasOne, Association::HasMany
            true
          else
            false
          end
        end
      end
    end

    # @param original [String]
    # @param other [String]
    # @return [Boolean]
    def self.secure_compare(original, other)
      original.bytesize == other.bytesize && OpenSSL.fixed_length_secure_compare(original, other)
    end
  end
end
