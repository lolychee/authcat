# frozen_string_literal: true

module Authcat
  module Credential
    module Reflections
      class Attribute
        include Base
        include Identifiable

        attr_reader :attribute_options

        def extract_attribute_options!(options)
          @attribute_options = options.fetch(:attribute, {})

          options
        end

        def extract_options!(*)
          extract_attribute_options!(super)
        end

        def type
          Type::Credential.new
        end

        def setup_attribute!
          owner.attribute name, type, **attribute_options
        end

        def setup_instance_methods!; end

        def setup!
          setup_attribute!
          setup_instance_methods!
        end
      end
    end
  end
end
