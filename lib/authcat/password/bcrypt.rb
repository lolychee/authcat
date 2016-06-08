require 'bcrypt'

module Authcat
  class Password
    class BCrypt < Password
      option(:cost, reader: true) { ::BCrypt::Engine.cost }

      option(:salt, reader: true) {|password| ::BCrypt::Engine.generate_salt(password.cost) }

      attr_reader :version

      def self.valid?(hashed_password)
        ::BCrypt::Password.valid_hash?(hashed_password)
      rescue
        false
      end

      def apply_options(options)
        if cost = options[:cost]
          range = ::BCrypt::Engine::MIN_COST..31
          raise ArgumentError, "cost must in #{range}" unless range.include?(cost)
        end
        super
      end

      def replace(str)
        extract_hash(super)
      end

      private

        def hash(password)
          ::BCrypt::Engine.hash_secret(password, salt)
        end

        def extract_hash(hashed_password)
          _, v, c, _ = hashed_password.split('$')

          @version = v.to_str
          options[:cost] = c.to_i
          options[:salt] = hashed_password[0, 29].to_str
          hashed_password
        end


        Password.register(:bcrypt, self)
    end
  end
end
