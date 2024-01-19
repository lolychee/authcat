# frozen_string_literal: true

require "active_record/type"

module Authcat
  module Credential
    module Type
      class Credential < ActiveRecord::Type::Serialized
        def initialize(cast_type, coder = nil, **options)
          coder ||= Coder.new
          super(cast_type, coder, **options)
        end

        class Coder
          def dump(value)
            value
          end

          def load(value)
            value
          end
        end
      end
    end
  end
end
