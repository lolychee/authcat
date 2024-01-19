# frozen_string_literal: true

module Authcat
  module Identifier
    module Reflections
      class HasOne < Authcat::Credential::Reflections::HasOne
        def setup_instance_methods!
          # return

          owner.class_eval <<-RUBY, __FILE__, __LINE__ + 1
            # frozen_string_literal: true

            def #{name}=(value)
              case value
              when String
                build_#{name}(identifier: value)
              end
            end
          RUBY
        end
      end
    end
  end
end
