# frozen_string_literal: true

require "phonelib"

module Authcat
  module Identity
    module Type
      class PhoneNumber < Identifier
        def encoder
          @encoder ||= Encoder.new(Value, **options)
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
