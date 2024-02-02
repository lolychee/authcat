# frozen_string_literal: true

module Authcat
  module Session
    module Reflections
      class HasOne < Authcat::Credential::Reflections::HasOne
        def identify(value)
          owner.includes(name).find_by(name => { token: value })
        end

        def setup_instance_methods!
          inverse_name = owner.reflect_on_association(name).send(:inverse_name)

          owner.class_eval <<-RUBY, __FILE__, __LINE__ + 1
            # frozen_string_literal: true

            def #{name}=(value)
              case value
              when String
                build_#{name}(#{inverse_name}: self, token: value)
              end
            end
          RUBY
        end
      end
    end
  end
end
