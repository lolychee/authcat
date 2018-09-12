# frozen_string_literal: true

begin
  require "bcrypt"
rescue LoadError
  $stderr.puts "You don't have bcrypt installed in your application. Please add it to your Gemfile and run bundle install"
  raise
end

module Authcat
  module Passwords
    class BCrypt < Abstract
      DEFAULT_OPTIONS = {
        cost: ::BCrypt::Engine.cost,
      }

      class << self
        def valid?(hashed_password, **opts)
          !!::BCrypt::Password.valid_hash?(hashed_password.to_str)
        end

        def valid_salt?(salt)
          !!::BCrypt::Engine.valid_salt?(salt)
        end

        def hash(password, **opts)
          options = DEFAULT_OPTIONS.merge(opts)
          salt = options[:salt] || ::BCrypt::Engine.generate_salt(options[:cost])
          raise ArgumentError, "invalid salt: #{salt.inspect}" unless valid_salt?(salt)

          ::BCrypt::Engine.hash_secret(password, salt)
        end
      end

      def initialize(hashed_password, **opts)
        super
        @options.merge!(extract_options(hashed_password)) if hashed_password
      end

      private

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
