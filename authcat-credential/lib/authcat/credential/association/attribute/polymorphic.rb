# frozen_string_literal: true

module Authcat
  module Credential
    module Association
      class Attribute
        module Polymorphic
          def polymorphic?
            options[:polymorphic]
          end

          def polymorphic_options
            raise NotImplementedError
          end

          def setup_attribute!
            return super unless polymorphic?

            owner.composed_of(name, **polymorphic_options)
          end
        end
      end
    end
  end
end
