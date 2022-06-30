# frozen_string_literal: true

module Authcat
  module Password
    class Attribute
      attr_reader :engine

      def initialize(klass, attribute_name, engine: Password.default_engine, array: false, **opts)
        @klass = klass
        @attribute_name = attribute_name
        @array = array
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

      def create(plaintext)
        @engine.create(plaintext, **@opts)
      end

      def verify(plaintext, ciphertext)
        @engine.verify(plaintext, ciphertext)
      end

      def to_type
        Type.new(attribute: self)
      end
    end
  end
end
