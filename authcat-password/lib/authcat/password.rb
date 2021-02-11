# frozen_string_literal: true

require 'zeitwerk'
loader = Zeitwerk::Loader.new
loader.tag = File.basename(__FILE__, '.rb')
loader.inflector = Zeitwerk::GemInflector.new(__FILE__)
loader.push_dir("#{__dir__}/..")
loader.setup

module Authcat
  class Password < ::String
    class << self
      # @return [Symbol, String, self]
      attr_accessor :default_algorithm
    end
    self.default_algorithm = :bcrypt

    # @return [self]
    def self.create(unencrypted_str, algorithm:, **opts)
      algorithm = Algorithm.build(algorithm, **opts)

      new(algorithm.digest(unencrypted_str), algorithm: algorithm, plaintext: unencrypted_str)
    end

    # @param original [String]
    # @param other [String]
    # @return [Boolean]
    def self.secure_compare(original, other)
      original.bytesize == other.bytesize &&
        original.each_byte.zip(other.each_byte).reduce(0) { |sum, pair| sum | (pair.first ^ pair.last) }.zero?
    end

    # @return [Algorithm]
    attr_reader :algorithm

    # @return [String, nil]
    attr_reader :plaintext

    # @return [self]
    def initialize(encrypted_str, algorithm:, plaintext: nil, **opts)
      @algorithm = Algorithm.build(algorithm, **opts)
      @algorithm.valid!(encrypted_str)
      @plaintext = plaintext
      super(encrypted_str)
    end

    # @return [Boolean]
    def verify(other)
      other = algorithm.digest(other) unless other.is_a?(self.class)

      self.class.secure_compare(to_s, other.to_s)
    end

    alias == verify
  end
end
