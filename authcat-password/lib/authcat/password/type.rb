# frozen_string_literal: true

module Authcat
  module Password
    class Type < ActiveModel::Type::String
      attr_reader :attribute

      def initialize(attribute:, **args)
        @attribute = attribute
        extend Array if @attribute.array?
        super(**args.slice(:precision, :scale, :limit))
      end

      def type
        :password
      end

      def serialize(value)
        return if value.nil?

        super.to_s
      end

      def cast_value(value)
        if attribute.valid?(value)
          attribute.new(value)
        else
          attribute.create(value)
        end
      end

      module Array
        def serialize(value)
          case value
          when ::Array
            value.map { |pwd| super(pwd) }.to_json
          end
        end

        def cast_value(value)
          case value
          when ::Array
            value.map { |pwd| super(pwd) }
          when String
            cast_value(JSON.parse(value))
          end
        end
      end
    end
  end
end
