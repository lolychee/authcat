# frozen_string_literal: true

gem 'bcrypt'
require 'bcrypt'

module Authcat
  class Password
    module Algorithms
      class BCrypt < Encryptor
        attr_reader :cost, :salt

        def new(encrypted_str = nil, **opts)
          super do
            self.options = opts.compact
            self.options = extract_options(encrypted_str) unless encrypted_str.nil?
          end
        end

        def cost=(value)
          raise ArgumentError if value < ::BCrypt::Engine::MIN_COST || value > ::BCrypt::Engine::MAX_COST

          @cost = value
        end

        def salt=(value)
          raise ArgumentError unless ::BCrypt::Engine.valid_salt?(value)

          @salt = value
        end

        def valid?(encrypted_str)
          !!::BCrypt::Password.valid_hash?(encrypted_str.to_s)
        end

        def verify(encrypted_str, unencrypted_str)
          verified = Utils.secure_compare(encrypted_str,
                                          digest(unencrypted_str, **extract_options(encrypted_str)))
          yield(encrypted_str) if verified && block_given?
          verified
        end

        def digest(unencrypted_str, cost: self.cost || ::BCrypt::Engine.cost, salt: ::BCrypt::Engine.generate_salt(cost))
          ::BCrypt::Engine.hash_secret(unencrypted_str, salt)
        end

        private

        def extract_options(unencrypted_str)
          _, v, c, = unencrypted_str.split('$')

          {
            # version: v.to_str,
            cost: c.to_i,
            salt: unencrypted_str[0, 29].to_str
          }
        end
      end
    end
  end
end
