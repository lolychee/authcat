# frozen_string_literal: true

module Authcat
  module IdP
    module Association
      class HasMany < Authcat::Credential::Association::HasMany
        def relation_class_name
          @relation_class_name ||= "#{owner.name}IdPCredential"
        end

        def identify(idp)
          case idp
          when OmniAuth::AuthHash
            owner.includes(name).find_by(idp_credentials: { name: name, provider: idp.provider, token: idp.uid })
          end
        end

        def relation_options
          @relation_options.merge(extend: Extension)
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
