# frozen_string_literal: true

gem "bcrypt"
require "bcrypt"

module Authcat
  module Password
    module KDF
      module BCrypt
        extend self

        # @param ciphertext [#to_s]
        # @return [Boolean]
        def valid?(ciphertext, **)
          !!::BCrypt::Password.valid_hash?(ciphertext.to_s)
        end

        # @param plaintext [#to_s]
        # @param cost [Integer]
        # @return [String]
        def create(plaintext, **opts)
          ::BCrypt::Password.create(plaintext.to_s, **opts.slice(:cost))
        end

        # @param ciphertext [#to_s]
        # @return [::BCrypt::Password]
        def new(ciphertext, **)
          ::BCrypt::Password.new(ciphertext.to_s)
        end

        # @param plaintext [#to_s]
        # @param ciphertext [#to_s]
        # @return [Boolean]
        def compare(plaintext, ciphertext)
          KDF.secure_compare(::BCrypt::Engine.hash_secret(plaintext, new(ciphertext).salt), ciphertext)
        end
      end
    end
  end
end
