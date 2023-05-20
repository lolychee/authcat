# frozen_string_literal: true

require "phonelib"

module Authcat
  module Identity
    module Type
      class PhoneNumber < Identifier
        def initialize(cast_type, **kwargs)
          @encoder = Encoder.new(**kwargs)
          super(cast_type, @encoder)
        end

        def serialize(value)
          @encoder.dump(@encoder.load(value))
        end

        class Encoder
          def initialize(**opts)
            @opts = opts
          end

          def parse(value, **opts)
            return value if value.is_a?(Value)

            Value.new(value.to_s, **@opts.merge(opts))
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

        class Value < Phonelib::Phone
          def initialize(value, **opts)
            country = opts.delete(:country)
            super(value, country)
          end

          alias as_json to_s

          def inspect
            to_s.inspect
          end
        end
      end
    end
  end
end
