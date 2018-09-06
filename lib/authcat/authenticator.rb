# frozen_string_literal: true

module Authcat
  class Authenticator
    include Enumerable

    ENV_KEY = "authcat.authenticator"

    attr_reader :tokens, :set_tokens, :delete_tokens

    def initialize(&block)
      @tokenizers = {}
      @tokens = {}
      @set_tokens = {}
      @delete_tokens = {}
    end

    def use(name, tokenizer)
      @tokenizers[name.to_sym] = tokenizer
    end

    def update(other_hash)
      @tokens.update(Hash[other_hash.map { |k, v| [k.to_sym, v] }])
    end

    def [](name)
      tokenizer = get_tokenizer(name)
      token = @tokens.fetch(name.to_sym) { return }
      tokenizer.untokenize(token)
    end

    def []=(name, identity)
      tokenizer = get_tokenizer(name)
      token = tokenizer.tokenize(identity)
      @set_tokens[name.to_sym] = token
    end

    def delete(name)
      @delete_tokens[name.to_sym] = true
    end

    private

      def get_tokenizer(name)
        @tokenizers.fetch(name.to_sym) { raise NameError, "Unknown name: #{name.inspect}" }
      end
  end
end
