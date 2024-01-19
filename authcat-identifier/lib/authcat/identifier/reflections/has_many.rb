# frozen_string_literal: true

module Authcat
  module Identifier
    module Reflections
      class HasMany < Authcat::Credential::Reflections::HasMany
        def setup_instance_methods!
          return
          inverse_of_name = owner.reflect_on_association(name).send(:inverse_name)

          owner.class_eval <<-RUBY, __FILE__, __LINE__ + 1
            # frozen_string_literal: true

            def #{name}=(value)
              case value
              when String
                build_#{name}(#{inverse_of_name}: self, identifier: value)
              end
            end
          RUBY
        end
      end
    end
  end
end
