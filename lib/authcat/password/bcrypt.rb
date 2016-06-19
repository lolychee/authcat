require 'bcrypt'

module Authcat
  class Password
    class BCrypt < Password
      MIN_COST = ::BCrypt::Engine::MIN_COST

      option(:cost, reader: true) { ::BCrypt::Engine.cost }

      option(:salt, reader: true) { generate_salt }

      attr_reader :version

      def self.valid?(hashed_password)
        ::BCrypt::Password.valid_hash?(hashed_password)
      end

      def self.valid_salt?(salt)
        ::BCrypt::Engine.valid_salt?(salt)
      end

      def replace(hashed_password)
        extract_hash(super)
      end

      def generate_salt(cost = self.cost)
        raise ArgumentError, "cost must be numeric and >= #{MIN_COST}" unless cost.is_a?(Integer) && cost >= MIN_COST

        ::BCrypt::Engine.generate_salt(cost)
      end

      private

        def hash(password, salt = self.salt)
          raise ArgumentError, "invalid salt: #{salt.inspect}" unless self.class.valid_salt?(salt)

          ::BCrypt::Engine.hash_secret(password, salt)
        end

        def extract_hash(hashed_password)
          _, v, c, _ = hashed_password.split('$')

          @version = v.to_str
          config.cost = c.to_i
          config.salt = hashed_password[0, 29].to_str
          hashed_password
        end

        Password.register(:bcrypt, self)
    end
  end
end
