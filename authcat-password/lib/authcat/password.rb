# frozen_string_literal: true

require 'zeitwerk'
loader = Zeitwerk::Loader.new
loader.tag = File.basename(__FILE__, '.rb')
loader.inflector = Zeitwerk::GemInflector.new(__FILE__)
loader.push_dir("#{__dir__}/..")
loader.ignore("#{__dir__}/password/algorithms")
loader.setup

module Authcat
  class Password < ::String
    # require_relative "password/extensions"

    # @return [self]
    def self.create(unencrypted_str, **opts)
      encryptor = Encryptor.build(**opts)
      new(encryptor.digest(unencrypted_str), encryptor: encryptor)
    end

    # @return [Encryptor]
    attr_reader :encryptor

    # @return [self]
    def initialize(encrypted_str, **opts)
      @encryptor = Encryptor.build(**opts)
      encryptor.valid!(encrypted_str)
      super(encrypted_str)
    end

    # @return [Boolean]
    def ==(other)
      if other.is_a?(self.class)
        Utils.secure_compare(self, other)
      else
        encryptor.verify(self, other)
      end
    end
  end
end
