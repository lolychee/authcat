module Authcat
  module Model
    module Tokenable
      extend ActiveSupport::Concern

      included do |base|
        tokenizer :jwt, signature_key: Authcat.secret_key

        if const_defined?(:GlobalID) && base < ::GlobalID::Identification
          extend ByGlobalID
        else
          extend ByID
        end
      end

      module ClassMethods
        def tokenizer(name = nil, **opts)
          return @tokenizer if name.nil?

          klass = Tokenizer.lookup(name)
          @tokenizer = klass.new(**opts)
        end
      end

      module ByGlobalID
        def untokenize(token)
          payload = tokenizer.untokenize(token)
          ::GlobalID.find(payload["gid".freeze])
        end

        def tokenize(identity)
          raise ArgumentError, "invalid identity: #{identity.inspect}" unless identity.is_a?(self)
          payload = { "gid".freeze => ::GlobalID.create(identity) }
          tokenizer.tokenize(payload)
        end
      end

      module ByID
        def untokenize(token)
          payload = tokenizer.untokenize(token)
          find(payload["id".freeze])
        end

        def tokenize(identity)
          raise ArgumentError, "invalid identity: #{identity.inspect}" unless identity.is_a?(self)
          payload = { "id".freeze => identity.id }
          tokenizer.tokenize(payload)
        end
      end
    end
  end
end
