# frozen_string_literal: true

module Authcat
  module Identity
    class Attribute
      attr_reader :klass, :name

      def initialize(klass, attribute_name, type: :token, **opts)
        @klass = klass
        @attribute_name = attribute_name
        @type = type.is_a?(Module) ? type : Identifiers.resolve(type)
        @opts = opts
      end

      def identify(value)
        @klass.find_by(@attribute_name => parse(value))
      end

      def parse(value)
        @type.parse(value, **@opts)
      end

      def valid?(value)
        @type.valid?(value, **@opts)
      end

      def to_type
        Type.new(attribute: self)
      end
    end
  end
end
