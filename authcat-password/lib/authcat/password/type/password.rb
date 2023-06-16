# frozen_string_literal: true

module Authcat
  module Password
    module Type
      class Password < Authcat::Credential::Type::Credential
        attr_reader :options

        # @return [Symbol, String, self]
        class_attribute :default_algorithm

        def initialize(cast_type, algorithm: default_algorithm, **options)
          @algorithm = algorithm
          @options = options
          super(cast_type, encoder)
        end

        def encoder
          @encoder ||= Encoder.new(Algorithm.resolve(@algorithm), **options)
        end

        def serialize(value)
          encoder.dump(encoder.load(value))
        end

        class Encoder
          def initialize(value_klass, **opts)
            @value_klass = value_klass
            @opts = opts
          end

          def parse(value, **opts)
            return value if value.is_a?(@value_klass)

            if value.is_a?(Algorithm::Plaintext)
              @value_klass.create(value.to_s, **@opts.merge(opts))
            else
              @value_klass.new(value.to_s, **@opts.merge(opts))
            end
          end

          def load(value)
            return nil if value.nil?

            parse(value)
          end

          def dump(value)
            return if value.nil?

            load(value).to_s
          end
        end
      end
    end
  end
end
