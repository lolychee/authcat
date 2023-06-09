# frozen_string_literal: true

module Authcat
  module Identifier
    module Type
      class Token < Identifier
        def value_klass
          Value
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
