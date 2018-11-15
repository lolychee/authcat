# frozen_string_literal: true

module Authcat
  module Token
    module Tokenizers
      class Abstract
        attr_reader :options

        def initialize(**opts)
          @options = opts
        end

        def tokenize(payload)
          raise NotImplementedError, "#tokenize not implemented."
        end

        def untokenize(token)
          raise NotImplementedError, "#untokenize not implemented."
        end
      end
    end
  end
end
