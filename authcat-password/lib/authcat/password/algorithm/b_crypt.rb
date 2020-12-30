# frozen_string_literal: true

gem 'bcrypt'
require 'bcrypt'

module Authcat
  class Password
    class Algorithm
      class BCrypt < Algorithm
        # @return [Integer]
        def cost
          @cost ||= ::BCrypt::Engine.cost
        end

        # @param value [Integer]
        # @return [Integer]
        def cost=(value)
          raise ArgumentError if value < ::BCrypt::Engine::MIN_COST || value > ::BCrypt::Engine::MAX_COST

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

        # @param encrypted_str [String]
        # @return [Boolean]
        def valid?(encrypted_str)
          !!::BCrypt::Password.valid_hash?(encrypted_str.to_s)
        end

        # @return [String]
        def digest(unencrypted_str)
          ::BCrypt::Engine.hash_secret(unencrypted_str, salt)
        end

        private

        # @param unencrypted_str [String]
        # @return [void]
        def extract_options_from_hash(unencrypted_str)
          _, v, c, = unencrypted_str.split('$')

          @version = v.to_str
          @cost = c.to_i
          @salt = unencrypted_str[0, 29].to_str
        end
      end
    end
  end
end
