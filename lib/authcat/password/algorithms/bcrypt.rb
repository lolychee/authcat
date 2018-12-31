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

          def valid?(hashed_password, **opts)
            !!::BCrypt::Password.valid_hash?(hashed_password.to_s)
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

          def hashed_password=(value)
            super
            @options.merge!(extract_options(value.to_s))
            value
          end

          def extract_options(hashed_password)
            _, v, c, _ = hashed_password.split("$")

            {
              version:  v.to_str,
              cost:     c.to_i,
              salt:     hashed_password[0, 29].to_str
            }
          end
      end
    end
  end
end
