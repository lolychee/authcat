# frozen_string_literal: true

require 'dry/container'
require 'forwardable'

module Authcat
  class Password
    class Algorithm
      class << self
        extend Forwardable

        def_delegators :registry, :register, :resolve

        def registry
          @registry ||= Dry::Container.new
        end

        # @param algorithm [Algorithm, Object, String, Symbol, #digest]
        # @return [self]
        def build(algorithm, **opts)
          if algorithm.is_a?(Class) && algorithm < Algorithm
            algorithm.new(**opts)
          elsif algorithm.is_a?(Algorithm) || algorithm.respond_to?(:digest)
            algorithm
          else
            Algorithm.resolve(algorithm).new(**opts)
          end
        end
      end

      # @return [String, nil]
      attr_reader :plaintext

      # @param encrypted_str [String]
      # @param plaintext [String]
      # @return [void]
      def initialize(encrypted_str = nil, **opts)
        new(encrypted_str, **opts)
      end

      # @return [self]
      def new(encrypted_str = nil, **opts)
        extract_options_from_hash(encrypted_str) unless encrypted_str.nil?
        extract_options(opts)

        dup.tap do |obj|
          yield(obj) if block_given?
        end
      end

      # @param encrypted_str [String]
      # @return [Boolean]
      def valid?(encrypted_str)
        !encrypted_str.empty?
      end

      # @param encrypted_str [String]
      # @return [Boolean]
      def valid!(encrypted_str)
        valid?(encrypted_str) || raise(ArgumentError, "Invalid password: #{encrypted_str.inspect}")
      end

      # @param unencrypted_str [#to_s]
      # @return [String]
      def digest(unencrypted_str)
        unencrypted_str.to_s
      end

      private

      # @param opts [Hash]
      # @reutrn [Hash]
      def extract_options(opts)
        opts
      end

      # @param encrypted_str [String]
      # @return [Hash]
      def extract_options_from_hash(_encrypted_str)
        {}
      end

      register(:bcrypt) { BCrypt }
    end
  end
end
