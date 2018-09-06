module Authcat
  module Tokenizer
    class Abstract
      attr_reader :options

      def initialize(**opts)
        @options = extract_options(opts)
      end

      def tokenize(payload)
        raise NotImplementedError, "#tokenize not implemented.".freeze
      end

      def untokenize(token)
        raise NotImplementedError, "#untokenize not implemented.".freeze
      end

      private

        def extract_options(opts)
          opts
        end
    end
  end
end
