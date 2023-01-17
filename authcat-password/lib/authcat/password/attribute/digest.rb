module Authcat
  module Password
    class Attribute
      class Digest < Attribute
        class << self
          attr_accessor :default_algorithm
        end
        self.default_algorithm = :bcrypt

        def initialize(*)
          super

          algorithm = options.fetch(:algorithm, self.class.default_algorithm)
          @algorithm = algorithm.is_a?(Module) ? algorithm : Algorithms.resolve(algorithm)
        end

        def valid?(ciphertext)
          @algorithm.valid?(ciphertext, **@options)
        end

        def new(ciphertext)
          @algorithm.new(ciphertext, **@options)
        end

        def create(*args)
          @algorithm.create(*args, **@options)
        end

        def verify(plaintext, ciphertext)
          !plaintext.nil? && !ciphertext.nil? && new(ciphertext).verify(plaintext)
        end
      end
    end
  end
end
