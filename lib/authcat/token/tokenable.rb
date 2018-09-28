# frozen_string_literal: true

module Authcat
  module Token
    module Tokenable
      def self.included(base)
        base.extend ClassMethods

        base.tokenable :jwt, signature_key_base: Authcat.secret_key
      end

      module ClassMethods
        def tokenable(name, **opts)
          klass = Tokenizers.lookup(name)
          @tokenizer = klass.new(**opts)
        end

        def untokenize(token, **opts)
          payload = @tokenizer.untokenize(token, **opts)
          block_given? ? yield(payload) : find(payload["id"])
        end

        def tokenize(identity, **opts)
          raise ArgumentError, "invalid identity: #{identity.inspect}" unless identity.is_a?(self)
          payload = block_given? ? yield(identity) : { "id" => identity.id }
          @tokenizer.tokenize(payload, **opts)
        end
      end
    end
  end
end
