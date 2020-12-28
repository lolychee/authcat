module Authcat
  class Password
    class Algorithm
      def self.registry
        @registry ||= {}
      end

      def self.register(name, class_name = Password.camalize(name), **opts)
        names = Array(opts[:alias]).compact << name
        names.each {|n| registry[n.to_s] = class_name }
      end

      # @return [self]
      def self.lookup(name)
        const_get(registry.fetch(name.to_s) { raise NameError, "unknown algorithm name: #{name.inspect}" })
      end

      # @param algorithm [Algorithm, Object, String, Symbol, #digest]
      # @return [self]
      def self.build(algorithm, **opts)
        if algorithm.is_a?(Class) && algorithm < Algorithm
          algorithm.new(**opts)
        elsif algorithm.is_a?(Algorithm) || algorithm.respond_to?(:digest)
          algorithm
        else
          Algorithm.lookup(algorithm).new(**opts)
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
    end
  end
end

Authcat::Password::Algorithm.register(:b_crypt, 'Authcat::Password::Algorithm::BCrypt', alias: :bcrypt)
