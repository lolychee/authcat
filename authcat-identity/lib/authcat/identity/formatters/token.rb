# frozen_string_literal: true

module Authcat
  module Identity
    module Formatters
      module Token
        module_function

        DEFAULT_VALIDATIONS_OPTIONS = { format: /^.+$/, allow_nil: true }.freeze

        def parse(value, **opts)
          return value if value.is_a?(Value)

          Value.new(value.to_s, **opts)
        end

        def valid?(value, **opts)
          parse(value.to_s, **opts).valid?
        end

        class Value < String
          def valid?
            !blank?
          end
        end
      end
    end
  end
end
