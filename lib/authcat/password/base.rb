module Authcat
  module Password
    class Base < String
    include Support::Configurable

      module ClassMethods
        def [](**options)
          Class.new(self) do configure(**options); end
        end

        def create(password, **options)
          new(**options).update(password)
        end

        def verify(hashed_password, password)
          new(hashed_password).verify(password)
        rescue InvalidHash
          false
        end

        def valid?(hashed_password)
          raise NotImplementedError, '.valid? not implemented.'
        end
      end
      extend ClassMethods

      def initialize(hashed_password = nil, **options)
        config.merge!(options)

        if hashed_password.nil?
          update('')
        else
          replace(hashed_password)
        end
      end

      def replace(hashed_password)
        raise InvalidHash, "invalid hash: #{hashed_password.inspect}." unless self.class.valid?(hashed_password)
        super
      end

      def update(password)
        replace(hash(password.to_s))
      end
      alias_method :<<, :update

      def ==(hashed_password)
        Password.secure_compare(self.to_s, hashed_password.to_s)
      end

      def verify(password)
        self == hash(password.to_s)
      end

      def digest(password)
        dup.update(password)
      end

      private

        def hash(password)
          raise NotImplementedError, '#hash not implemented.'
        end

        class InvalidHash < StandardError; end

    end
  end
end
