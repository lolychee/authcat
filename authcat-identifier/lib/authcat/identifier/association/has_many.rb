# frozen_string_literal: true

module Authcat
  module Identifier
    module Association
      class HasMany < Authcat::Credential::Association::HasMany
        def identify(value)
          owner.includes(name).find_by(name => { identifier: value })
        end

        def setup_instance_methods!
          return
          owner.class_eval <<-RUBY, __FILE__, __LINE__ + 1
            # frozen_string_literal: true

            def #{name}=(value)
              case value
              when String
                build_#{name}(#{relation_options[:inverse_of]}: self, identifier: value)
              end
            end
          RUBY
        end
      end
    end
  end
end
