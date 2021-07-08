# frozen_string_literal: true

require "zeitwerk"
loader = Zeitwerk::Loader.new
loader.tag = File.basename(__FILE__, ".rb")
loader.inflector = Zeitwerk::GemInflector.new(__FILE__)
loader.push_dir("#{__dir__}/..")
loader.setup

module Authcat
  class Password < ::String
    class << self
      # @return [Symbol, String, self]
      attr_accessor :default_crypto

      # @return [self]
      def create(plaintext, crypto:, **opts)
         crypto = Crypto.build(crypto, **opts)

        new(crypto.generate(plaintext), crypto: crypto)
      end

    end

    self.default_crypto = :bcrypt

    # @return [Crypto]
    attr_reader :crypto

    # @return [self]
    def initialize(ciphertext, crypto:, **opts)
      @crypto = Crypto.build(crypto, ciphertext, **opts)
      super(ciphertext)
    end

    # @return [Boolean]
    def verify(other)
      @crypto.verify(self, other)
    end

    alias == verify
  end
end
