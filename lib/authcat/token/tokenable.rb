# frozen_string_literal: true

module Authcat
  module Token
    module Tokenable
      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        def tokenable(name = Token.default_tokenizer, **opts)
          klass = Tokenizers.lookup(name)
          @tokenizer = klass.new(**opts)
        end

        def untokenize(token, **opts)
          payload = @tokenizer.untokenize(token, **opts)
          new.token_load(payload)
        end

        def tokenize(identity, **opts)
          raise ArgumentError, "invalid identity: #{identity.inspect}" unless identity.is_a?(self)
          payload = identity.token_dump
          @tokenizer.tokenize(payload, **opts)
        end
      end

      def token_dump
        { "id" => self.id.to_s }
      end

      def token_load(payload)
        self.id = payload["id"]
        reload
      end
    end
  end
end
