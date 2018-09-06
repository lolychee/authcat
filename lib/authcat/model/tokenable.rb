# frozen_string_literal: true

module Authcat
  module Model
    module Tokenable
      def self.included(base)
        base.extend ClassMethods

        base.tokenizer :jwt, signature_key: Authcat.secret_key
      end

      module ClassMethods
        def tokenizer(name = nil, **opts)
          return @tokenizer if name.nil?

          klass = Tokenizers.lookup(name)
          @tokenizer = klass.new(**opts)
        end

        def untokenize(token)
          payload = tokenizer.untokenize(token)
          find(payload["id"])
        end

        def tokenize(identity)
          raise ArgumentError, "invalid identity: #{identity.inspect}" unless identity.is_a?(self)
          payload = { "id" => identity.id }
          tokenizer.tokenize(payload)
        end
      end
    end
  end
end
