# frozen_string_literal: true

module Authcat
  module Password
    class Attribute
      attr_reader :engine

      def initialize(klass, attribute_name, engine: Password.default_engine, array: false, **opts)
        @klass = klass
        @attribute_name = attribute_name
        @array = array
        extend SupportArray if @array
        @engine = engine.is_a?(Module) ? engine : Engines.resolve(engine)
        @opts = opts
      end

      def array?
        @array
      end

      def valid?(ciphertext)
        @engine.valid?(ciphertext, **@opts)
      end

      def new(ciphertext)
        @engine.new(ciphertext, **@opts)
      end

      def create(*args)
        @engine.create(*args, **@opts)
      end

      def verify(plaintext, ciphertext)
        @engine.verify(plaintext, ciphertext)
      end

      def to_type
        Type.new(attribute: self)
      end

      module SupportArray
        def create(passwords = [], *args)
          Array(passwords).map { |pwd| super(pwd, *args) }
        end

        def verify(plaintext, ciphertext)
          Array(ciphertext).any? { |pwd| super(plaintext, pwd) }
        end
      end
    end
  end
end
