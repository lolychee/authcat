# frozen_string_literal: true

require "omniauth"

module Authcat
  module IdentityProvider
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

        def new(identity_provider)
          case identity_provider
          when OmniAuth::AuthHash
            type = sti_class_for(identity_provider.provider.classify)
            puts type
            type.new(token: identity_provider.uid, metadata: identity_provider.info)
          else
            super
          end
        end
      end
    end
  end
end
