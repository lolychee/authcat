module Authcat
  module Tokenizer
    class Abstract
      def initialize(**opts)
        @options = opts
      end

      def encode(payload)
        raise NotImplementedError, "#encode not implemented."
      end

      def decode(token)
        raise NotImplementedError, "#decode not implemented."
      end
    end
  end
end
