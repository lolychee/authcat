# frozen_string_literal: true

module Authcat
  module Token
    module Tokenizers
      class Abstract
        attr_reader :options

        def initialize(**opts)
          @options = extract_options(opts)
        end

        def tokenize(payload)
          raise NotImplementedError, "#tokenize not implemented."
        end

        def untokenize(token)
          raise NotImplementedError, "#untokenize not implemented."
        end

        private

          def extract_options(opts)
            opts
          end
      end
    end
  end
end
