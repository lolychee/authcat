require "omniauth"

module Authcat
  module IdP
    module Omniauth
      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        def omniauth
          @omniauth_middleware = Builder.new(&block)
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
