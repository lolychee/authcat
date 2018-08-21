module Authcat
  module Model
    module Tokenable
      include Locatable
      extend ActiveSupport::Concern

      included do
        tokenizer :jwt, secret_key: Rails.application.secrets.secret_key_base
      end

      module ClassMethods
        def tokenizer(name, **opts)
          klass = Tokenizer.lookup(name)
          @tokenizer = klass.new(**opts)
        end

        def find_by_token(token)
          payload, headers = @tokenizer.decode(token)

          find_by_location(payload)
        end

        def to_token(identity)
          @tokenizer.encode(to_location(identity))
        end
      end

      def to_token
        self.class.to_token(self)
      end
    end
  end
end