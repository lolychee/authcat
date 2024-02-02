# frozen_string_literal: true

module Authcat
  module Credential
    module Reflections
      class Attribute
        include Base

        attr_reader :attribute_options

        def extract_attribute_options!(options)
          @attribute_options = options.extract!(:default)

          options
        end

        def extract_options!(options)
          extract_attribute_options!(super)
        end

        def type_class
          Type::Credential
        end

        def type_options
          options
        end

        def setup_attribute!
          owner.attribute(name, **attribute_options) do |cast_type|
            type_class.new(cast_type, **type_options)
          end
        end

        def setup!
          setup_attribute!
          super
        end
      end
    end
  end
end
