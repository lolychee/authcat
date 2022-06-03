# frozen_string_literal: true

require "dry/container"
require "forwardable"

module Authcat
  module Password
    module KDF
      class << self
        extend Forwardable

        def_delegators :registry, :register, :resolve

        # @return [Dry::Container]
        def registry
          @registry ||= Dry::Container.new
        end

        # @param original [String]
        # @param other [String]
        # @return [Boolean]
        def secure_compare(original, other)
          original.bytesize == other.bytesize && OpenSSL.fixed_length_secure_compare(original, other)
        end
      end

      register(:plaintext) { Plaintext }
      register(:bcrypt) { BCrypt }
    end
  end
end
