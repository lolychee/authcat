# frozen_string_literal: true

gem "bcrypt"
require "bcrypt"

module Authcat
  module Password
    class Crypto
      class BCrypt < Crypto
        # @return [Integer]
        def cost
          @cost ||= ::BCrypt::Engine.cost
        end

        # @param value [Integer]
        # @return [Integer]
        def cost=(value)
          raise ArgumentError unless value.between?(::BCrypt::Engine::MIN_COST, ::BCrypt::Engine::MAX_COST)

          @cost = value
        end

        # @return [String]
        def salt
          @salt ||= ::BCrypt::Engine.generate_salt(cost)
        end

        # @param value [String]
        # @return [String]
        def salt=(value)
          raise ArgumentError unless ::BCrypt::Engine.valid_salt?(value)

          @salt = value
        end

        # @param ciphertext [String]
        # @return [Boolean]
        def valid?(ciphertext)
          !!::BCrypt::Password.valid_hash?(ciphertext.to_s)
        end

        # @return [String]
        def generate(plaintext)
          ::BCrypt::Engine.hash_secret(plaintext, salt)
        end

        private

        # @param ciphertext [String]
        # @return [void]
        def extract_options(ciphertext, **opts)
          if !ciphertext.nil? && valid!(ciphertext)
            _, v, c, = ciphertext.split("$")

            @version = v.to_str
            @cost = c.to_i
            @salt = ciphertext[0, 29].to_str
          end

          super
        end
      end
    end
  end
end
