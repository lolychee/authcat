# frozen_string_literal: true

module Authcat
  module Identity
    class Type < ActiveModel::Type::String
      attr_reader :attribute

      def initialize(**args)
        @attribute = args.fetch(:attribute) { raise ArgumentError, ":attribute is required" }
        # extend Array if @attribute.array?
        super(**args.slice(:precision, :scale, :limit))
      end

      def type
        :identifier
      end

      def serialize(value)
        return if value.nil?

        super.to_s
      end

      def cast_value(value)
        attribute.parse(value)
      end

      module Array
        def serialize(value)
          case value
          when Array
            value.map { |pwd| super(pwd) }.to_json
          end
        end

        def cast_value(value)
          case value
          when Array
            value.map { |pwd| super(pwd) }
          when String
            case_value(JSON.parse(value))
          end
        end
      end
    end
  end
end
