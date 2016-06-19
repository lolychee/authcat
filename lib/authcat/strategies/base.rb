module Authcat
  module Strategies
    class Base
      include Support::Configurable

      def initialize(**options)
        raise 'this is an abstract class.' if self === Strategies::Base

        config.merge!(options)
      end

      def find_credential(request)
        nil
      end

      def save_credential(request, credential)
        raise "#{self.class.inspect} is readonly strategy." if readonly?
        raise ArgumentError, "given credential must be #{credential_class.inspect} instance." unless credential.nil? || credential.is_a?(credential_class)
      end

      def has_credential?(request)
        false
      end

      def find_user(request)
        credential = find_credential(request)

        credential.nil? ? nil : credential.to_user
      end

      def save_user(request, user)
        credential = user.nil? ? nil : create_credential(user)
        save_credential(request, credential)
      end

      def parse_credential(credential)
        credential_class.new(credential)
      end

      def create_credential(user)
        credential_class.create(user)
      end

      def credential_class
        Credentials::GlobalID
      end

      def readonly?
        true
      end

    end
  end
end
