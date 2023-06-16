# frozen_string_literal: true

module Authcat
  module Credential
    module Association
      class Attribute
        module Base
          def setup!
            setup_attribute!
            setup_instance_methods!
          end

          def setup_attribute!
            owner.attribute name do |cast_type|
              type_class.new(cast_type, **type_options)
            end
          end
        end

        include Relatable
        include Base
        include Array
      end
    end
  end
end
