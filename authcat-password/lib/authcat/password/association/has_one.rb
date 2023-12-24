# frozen_string_literal: true

module Authcat
  module Password
    module Association
      class HasOne < Authcat::Credential::Association::HasOne
        def identifiable?
          false
        end

        def setup_instance_methods!
          owner.class_eval <<-RUBY, __FILE__, __LINE__ + 1
            # frozen_string_literal: true

            def #{name}=(value)
              case value
              when String
                build_#{name}(#{relation_options[:inverse_of]}: self, password: value)
              end
            end
          RUBY
        end
      end
    end
  end
end
