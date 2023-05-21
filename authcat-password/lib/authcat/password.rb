# frozen_string_literal: true

require "active_support"
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
    extend ActiveSupport::Concern

    include Marcos
    include Validators

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
