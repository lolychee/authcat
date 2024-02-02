# frozen_string_literal: true

module Authcat
  module Password
    module Reflections
      class HasOne < Authcat::Credential::Reflections::HasOne
        def identifiable?
          false
        end

        def setup_instance_methods!
          inverse_of_name = owner.reflect_on_association(name).inverse_of.name

          owner.class_eval <<-RUBY, __FILE__, __LINE__ + 1
            # frozen_string_literal: true

            def #{name}=(value)
              case value
              when String
                build_#{name}(#{inverse_of_name}: self, password: value)
              end
            end
          RUBY
        end
      end
    end
  end
end
