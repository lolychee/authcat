# frozen_string_literal: true

require "active_support"
require "zeitwerk"

module Authcat
  module Password
    def self.loader
      @loader ||= Zeitwerk::Loader.for_gem_extension(Authcat)
    end

    loader.inflector.inflect(
      "bcrypt" => "BCrypt",
      "totp" => "TOTP",
      "hotp" => "HOTP"
    )
    loader.setup

    def self.included(base)
      base.extend ClassMethods
      base.include Marcos
    end

    module ClassMethods
      def passwords
        credentials.select do |_, credential|
          case credential
          when Reflections::Attribute, Reflections::HasOne, Reflections::HasMany
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
