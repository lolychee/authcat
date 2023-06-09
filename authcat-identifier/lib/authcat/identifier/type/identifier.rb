# frozen_string_literal: true

module Authcat
  module Identifier
    module Type
      class Identifier < Authcat::Credential::Type::Credential
        attr_reader :options

        def initialize(cast_type, **options)
          @options = options
          super(cast_type, encoder)
        end

        def encoder
          @encoder ||= Encoder.new(value_klass, **options)
        end

        def value_klass
          Value
        end

        def serialize(value)
          encoder.dump(value)
        end

        class Encoder
          def initialize(value_klass, **opts)
            @value_klass = value_klass
            @opts = opts
          end

          def parse(value, **opts)
            return value if value.is_a?(@value_klass)

            @value_klass.new(value.to_s, **@opts.merge(opts))
          end

          def load(value)
            return if value.nil?

            parse(value)
          end

          def dump(value)
            return if value.nil?

            load(value).to_s
          end
        end

        class Value < String
        end
      end
    end
  end
end
