# frozen_string_literal: true

module Authcat
  class Password
    class Encryptor
      class << self
        # @return [Symbol, String, self]
        attr_accessor :default_algorithm
      end
      self.default_algorithm = :bcrypt

      # @return [self]
      def self.build(encrypted_str = nil, encryptor: nil, algorithm: default_algorithm, **opts)
        (encryptor || Algorithms.lookup(algorithm)).new(encrypted_str, **opts)
      end

      def initialize(encrypted_str = nil, **opts)
        new(encrypted_str, **opts)
      end

      def new(*, &block)
        dup.tap(&block)
      end

      def valid?(_encrypted_str)
        raise NotImplementedError, '#valid? not implemented.'
      end

      def valid!(encrypted_str)
        raise ArgumentError, "Invalid password: #{encrypted_str.inspect}" unless valid?(encrypted_str)
      end

      def digest(_unencrypted_str, **_opts)
        raise NotImplementedError, '#digest not implemented.'
      end

      def verify(_encrypted_str, _unencrypted_str)
        raise NotImplementedError, '#verify not implemented.'
      end

      def options=(opts)
        opts.each { |k, v| send("#{k}=", v) }
      end
    end
  end
end
