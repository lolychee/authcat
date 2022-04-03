# frozen_string_literal: true

require "zeitwerk"
loader = Zeitwerk::Loader.new
loader.tag = File.basename(__FILE__, ".rb")
loader.inflector = Zeitwerk::GemInflector.new(__FILE__)
loader.push_dir("#{__dir__}/..")
loader.setup

module Authcat
  module Password
    class << self
      # @return [Symbol, String, self]
      attr_accessor :default_crypto

      # @return [self]
      def create(*args, crypto:, **opts)
        crypto = Crypto.build(crypto, **opts)

        Value.new(crypto.valid_or_generate(*args), crypto: crypto)
      end
    end

    self.default_crypto = :bcrypt

    def self.included(base)
      base.include HasPassword,
                   Validators
    end
  end
end
