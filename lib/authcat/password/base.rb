module Authcat
  module Password
    class Base < String
      include Support::Configurable

      class << self
        def create(password, **options)
          new(**options).update(password)
        end

        def parse(hashed_password, **options)
          new(hashed_password, **options)
        end

        def valid?(hash_password, **options)
          raise NotImplementedError, ".valid? not implemented."
        end
      end

      def initialize(hashed_password = nil, **options)
        config.merge!(options)

        if hashed_password.nil?
          update("")
        else
          replace(hashed_password)
        end
      end

      def replace(hashed_password)
        raise InvalidHash, "invalid hash: #{hashed_password.inspect}." unless self.class.valid?(hashed_password)
        super
      end

      def update(password)
        replace(hash_function(password.to_s))
      end
      alias_method :<<, :update

      def ==(hashed_password)
        Password.secure_compare(self.to_s, hashed_password.to_s)
      end

      def verify(password)
        self == hash_function(password.to_s)
      end

      def digest(password)
        dup.update(password)
      end

      private

        def hash_function(*)
          raise NotImplementedError, "#hash not implemented."
        end

        class InvalidHash < StandardError; end
    end
  end
end
