module Authcat
  module IdP
    module Omniauth
      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        def omniauth_provider(_name)
          @omniauth_middleware = Builder.new(&block)
        end
      end

      attr_reader :omniauth_hash

      def omniauth_hash=(hash)
        case hash
        when OmniAuth::AuthHash
          @omniauth_hash = hash

          self.provider = hash.provider
          self.token = hash.uid
          self.metadata = hash.info
        end
      end
    end
  end
end
