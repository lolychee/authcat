# frozen_string_literal: true

module Authcat
  module Identifier
    module Association
      class HasOne < Authcat::Credential::Association::HasOne
        def relation_class_name
          @relation_class_name ||= "#{owner.name}Identifier"
        end

        def identify(value)
          owner.includes(name).find_by(name => { identifier: value })
        end

        def setup!
          setup_relation!
          setup_instance_methods!
        end

        def setup_instance_methods!
          owner.class_eval <<-CODE, __FILE__, __LINE__ + 1
            # frozen_string_literal: true

            def #{name}=(value)
              case value
              when String
                build_#{name}(#{@relation_options[:inverse_of]}: self, identifier: value, identifier_type: "#{@type}")
              end
            end
          CODE
        end
      end
    end
  end
end
