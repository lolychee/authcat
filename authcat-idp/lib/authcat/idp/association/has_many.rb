# frozen_string_literal: true

module Authcat
  module IdP
    module Association
      class HasMany < Authcat::Credential::Association::HasMany
        def identify(idp)
          case idp
          when OmniAuth::AuthHash
            owner.includes(name).find_by(name => { provider: idp.provider, token: idp.uid })
          end
        end

        def relation_options
          @relation_options.merge(extend: Extension)
        end

        def setup_instance_methods!
          owner.class_eval <<-RUBY, __FILE__, __LINE__ + 1
            # frozen_string_literal: true

            def #{name}=(value)
              case value
              when String
                build_#{name}(#{relation_options[:inverse_of]}: self, token: value)
              end
            end
          RUBY
        end

        module Extension
          def verify(idp)
            case idp
            when OmniAuth::AuthHash
              where(new(idp).slice(:provider, :token)).exists?
            end
          end
        end
      end
    end
  end
end
