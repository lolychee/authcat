# frozen_string_literal: true

module Authcat
  module Identifier
    module Type
      class Token < Identifier
        def encoder
          @encoder ||= Encoder.new(Value, **options)
        end

        class Value < String
          def initialize(value, **_opts)
            super(value)
          end
        end
      end
    end
  end
end
