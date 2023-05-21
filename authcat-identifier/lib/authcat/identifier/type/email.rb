# frozen_string_literal: true

require "valid_email2"

module Authcat
  module Identifier
    module Type
      class Email < Identifier
        def encoder
          @encoder ||= Encoder.new(Value, **options)
        end

        class Value < ValidEmail2::Address
          def initialize(value, **_opts)
            super(value)
          end

          def to_s
            @raw_address
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
