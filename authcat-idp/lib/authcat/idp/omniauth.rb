require "omniauth"

module Authcat
  module IdP
    module Omniauth
      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        attr_writer :omniauth_options

        def omniauth_options
          @omniauth_options ||= {}
        end

        def omniauth_providers
          @omniauth_providers ||= {}
        end

        def omniauth_provider(name, *args, **opts, &block)
          omniauth_providers[name] = [name, args, opts, block]
        end
      end

      def initialize(idp)
        case idp
        when OmniAuth::AuthHash
          super({ provider: idp.provider, token: idp.uid, metadata: idp.info })
        else
          super
        end
      end
    end
  end
end
