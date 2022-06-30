# frozen_string_literal: true

gem "valid_email2"
require "valid_email2"

module Authcat
  module Identity
    module Identifiers
      module Email
        module_function

        DEFAULT_VALIDATIONS_OPTIONS = { "valid_email_2/email": true, allow_nil: true }.freeze
        DEFAULT_MASK_OPTIONS = { pattern: /^.{1}(?<name_mask>.*).{2}@.{1}(?<domain_mask>.*)\..+$/ }.freeze

        def parse(value, **opts)
          return value if value.is_a?(Value)

          Value.new(value.to_s, **opts)
        end

        def valid?(value, **opts)
          parse(value.to_s, **opts).valid?
        end

        class Value < ValidEmail2::Address
          def initialize(value, **_opts)
            super(value)
          end

          def to_s
            @raw_address
          end

          def inspect
            to_s.inspect
          end
        end
      end
    end
  end
end
