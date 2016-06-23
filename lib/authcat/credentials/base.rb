module Authcat
  module Credentials
    class Base < String
      include Support::Configurable

      module ClassMethods
        def create(user, **options)
          new(generate_credential(user), **options)
        end

        def valid?(credential)
          raise NotImplementedError, '.valid? not implemented.'
        end

        def generate_credential(user)
          raise NotImplementedError, '.generate_credential not implemented.'
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
        replace(self.class.generate_credential(user))
      end

      def find_user
        raise NotImplementedError, '#find_user not implemented.'
      end

    end
  end
end
