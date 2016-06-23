module Authcat
  class Password
    class BCrypt < Password

      begin
        require 'bcrypt'
      rescue LoadError
        $stderr.puts "You don't have bcrypt installed in your application. Please add it to your Gemfile and run bundle install"
        raise
      end

      option(:cost) { ::BCrypt::Engine.cost }

      option(:min_cost) { ::BCrypt::Engine::MIN_COST }

      option(:salt) {|password| password.generate_salt }

      attr_reader :version

      def self.valid?(hashed_password)
        !!::BCrypt::Password.valid_hash?(hashed_password)
      end

      def self.valid_salt?(salt)
        !!::BCrypt::Engine.valid_salt?(salt)
      end

      def replace(hashed_password)
        extract_hash(super)
      end

      def generate_salt(cost = self.cost)
        raise ArgumentError, "cost should be numeric and >= #{min_cost}" unless cost.is_a?(Integer) && cost >= min_cost

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
          self.cost = c.to_i
          self.salt = hashed_password[0, 29].to_str

          hashed_password
        end

    end
  end
end
