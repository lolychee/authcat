# frozen_string_literal: true

require "active_record/type"

module Authcat
  module Credential
    module Type
      class Credential < ActiveRecord::Type::Serialized
        class_attribute :default_options, default: {}

        def initialize(cast_type, coder = nil, **options)
          super(cast_type, coder || build_coder(default_options.merge(options)))
        end

        def build_coder(_options)
          Coder.new
        end

        class Coder
          def dump(value) = value

          def load(value) = value
        end
      end
    end
  end
end
