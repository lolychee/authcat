# frozen_string_literal: true

begin
  require "bcrypt"
rescue LoadError
  $stderr.puts "You don't have bcrypt installed in your application. Please add it to your Gemfile and run bundle install"
  raise
end

module Authcat
  module Password
    module Algorithms
      class BCrypt < Abstract
        class << self
          attr_accessor :cost

          def valid?(password_digest, **opts)
            !!::BCrypt::Password.valid_hash?(password_digest.to_s)
          end

          def valid_salt?(salt)
            !!::BCrypt::Engine.valid_salt?(salt)
          end

          def __hash__(password, **opts)
            options = default_options.merge(opts)
            salt = options[:salt] || ::BCrypt::Engine.generate_salt(options[:cost])
            raise ArgumentError, "invalid salt: #{salt.inspect}" unless valid_salt?(salt)

            ::BCrypt::Engine.hash_secret(password, salt)
          end

          def default_options
            { cost: self.cost }
          end
        end
        self.cost = ::BCrypt::Engine.cost

        private

          def password_digest=(value)
            super
            @options.merge!(extract_options(value.to_s))
            value
          end

          def extract_options(password_digest)
            _, v, c, _ = password_digest.split("$")

            {
              version:  v.to_str,
              cost:     c.to_i,
              salt:     password_digest[0, 29].to_str
            }
          end
      end
    end
  end
end
