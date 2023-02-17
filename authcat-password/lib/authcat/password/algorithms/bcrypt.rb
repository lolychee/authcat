# frozen_string_literal: true

gem "bcrypt"
require "bcrypt"

module Authcat
  module Password
    module Algorithms
      module BCrypt
        module_function

        # @param ciphertext [#to_s]
        # @return [Boolean]
        def valid?(ciphertext, **)
          !!Value.valid_hash?(ciphertext.to_s)
        end

        # @param plaintext [#to_s]
        # @param cost [Integer]
        # @return [String]
        def create(plaintext, **opts)
          Value.create(plaintext.to_s, **opts.slice(:cost))
        end

        # @param ciphertext [#to_s]
        # @return [::BCrypt::Password]
        def new(ciphertext, **)
          Value.new(ciphertext.to_s)
        end

        # @param plaintext [#to_s]
        # @param ciphertext [#to_s]
        # @return [Boolean]
        def verify(plaintext, ciphertext)
          Password.secure_compare(::BCrypt::Engine.hash_secret(plaintext, new(ciphertext).salt), ciphertext)
        end

        class Value < ::BCrypt::Password
          def verify(plaintext, **_opts)
            Algorithms::BCrypt.verify(plaintext, to_s)
          end
        end
      end
    end
  end
end
