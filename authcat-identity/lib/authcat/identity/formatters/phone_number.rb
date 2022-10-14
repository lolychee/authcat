# frozen_string_literal: true

gem "phonelib"
require "phonelib"

module Authcat
  module Identity
    module Formatters
      module PhoneNumber
        module_function

        DEFAULT_VALIDATIONS_OPTIONS = { phone: true, allow_nil: true }.freeze
        DEFAULT_MASK_OPTIONS = { pattern: /^\d{3}(?<mask>\d{4})\d{4}$/ }.freeze

        def parse(value, **opts)
          return value if value.is_a?(Value)

          Value.new(value, **opts)
        end

        def valid?(value, **opts)
          parse(value, **opts).valid?
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
