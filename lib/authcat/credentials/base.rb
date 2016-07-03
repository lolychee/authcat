module Authcat
  module Credentials
    class Base < String
      include Support::Configurable

      module ClassMethods
        def [](**options)
          Class.new(self) do configure(**options); end
        end

        def create(user, **options)
          raise NotImplementedError, '.create not implemented.'
        end

        def valid?(credential)
          raise NotImplementedError, '.valid? not implemented.'
        end
      end
      extend ClassMethods

      def initialize(credential, **options)
        config.merge!(options)

        replace(credential)
      end

      def replace(credential)
        raise InvalidCredential, "invalid credential: #{credential.inspect}." unless self.class.valid?(credential)
        super
      end

      def update(user)
        replace(self.class.create(user))
      end

      def find
        raise NotImplementedError, '#find not implemented.'
      end

    end
  end
end
