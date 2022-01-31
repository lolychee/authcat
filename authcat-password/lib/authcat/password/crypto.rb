# frozen_string_literal: true

require "dry/container"
require "forwardable"

module Authcat
  class Password
    class Crypto
      class << self
        extend Forwardable

        def_delegators :registry, :register, :resolve

        def registry
          @registry ||= Dry::Container.new
        end

        # @param crypto [Crypto, Object, String, Symbol, #digest]
        # @return [self]
        def build(crypto, *args, **opts)
          return crypto if crypto.is_a?(self)

          klass = crypto.is_a?(Class) && crypto < self ? crypto : Crypto.resolve(crypto)
          klass.new(*args, **opts)
        end

        # @param original [String]
        # @param other [String]
        # @return [Boolean]
        def secure_compare(original, other)
          original.bytesize == other.bytesize &&
            original.each_byte.zip(other.each_byte).reduce(0) { |sum, pair| sum | (pair.first ^ pair.last) }.zero?
        end
      end

      # @param ciphertext [String]
      # @return [void]
      def initialize(ciphertext = nil, **opts)
        extract_options(ciphertext, **opts)
      end

      # @return [self]
      def new(ciphertext, **opts)
        dup.tap do |obj|
          obj.instance_exec { initialize(ciphertext, **opts) }
          yield(obj) if block_given?
        end
      end

      # @param ciphertext [String]
      # @return [Boolean]
      def valid?(ciphertext)
        !ciphertext.empty?
      end

      # @param ciphertext [String]
      # @return [Boolean]
      def valid!(ciphertext)
        valid?(ciphertext) || raise(ArgumentError, "Invalid ciphertext: #{ciphertext.inspect}")
      end

      # @param ciphertext [#to_s]
      # @return [String]
      def generate(ciphertext)
        ciphertext.to_s
      end

      # @param ciphertext [#to_s]
      # @return [String]
      def valid_or_generate(ciphertext)
        valid?(ciphertext) ? ciphertext : generate(ciphertext)
      end

      def verify(ciphertext, other)
        other = generate(other.to_s) unless other.is_a?(Password) && self == other.crypto
        self.class.secure_compare(ciphertext, other.to_s)
      end

      alias == verify

      private

      # @param opts [Hash]
      # @reutrn [Hash]
      def extract_options(_ciphertext, **opts)
        opts
      end

      class Plaintext < Crypto; end

      register(:plaintext) { Plaintext }
      register(:bcrypt) { BCrypt }
    end
  end
end
