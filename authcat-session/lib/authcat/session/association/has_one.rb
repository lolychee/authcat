# frozen_string_literal: true

module Authcat
  module Session
    module Association
      class HasOne < Authcat::Credential::Association::HasOne
        def identify(value)
          owner.includes(name).find_by(name => { token: value })
        end

        def setup_instance_methods!
          owner.class_eval <<-CODE, __FILE__, __LINE__ + 1
            # frozen_string_literal: true

            def #{name}=(value)
              case value
              when String
                build_#{name}(#{relation_options[:inverse_of]}: self, token: value)
              end
            end
          CODE
        end
      end
    end
  end
end
