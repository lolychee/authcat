# frozen_string_literal: true

module Authcat
  module IdentityProvider
    module Reflections
      class HasMany < Authcat::Credential::Reflections::HasMany
        def identify(identity_provider)
          case identity_provider
          when OmniAuth::AuthHash
            type = @association.klass.sti_class_for(identity_provider.provider.classify)
            owner.includes(name).find_by(name => { type: type.sti_name, token: identity_provider.uid })
          end
        end

        def relation_options
          @relation_options.merge(extend: Extension)
        end

        def setup_instance_methods!
          inverse_of_name = owner.reflect_on_association(name).send(:inverse_name)

          owner.class_eval <<-RUBY, __FILE__, __LINE__ + 1
            # frozen_string_literal: true

            def #{name}=(value)
              case value
              when String
                build_#{name}(#{inverse_of_name}: self, token: value)
              end
            end
          RUBY
        end

        module Extension
          def verify(identity_provider)
            case identity_provider
            when OmniAuth::AuthHash
              type = @association.klass.sti_class_for(identity_provider.provider.classify)
              where(token: identity_provider.uid).scoping do
                type.exists?
              end
            end
          end
        end
      end
    end
  end
end
