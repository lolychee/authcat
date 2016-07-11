module Authcat
  module Strategies
    class Debug < Base

      def authenticate
        identity = credential.find
        yield identity if identity && block_given?
      end

      def sign_in(identity = auth.identity)
        self.credential = credential_class.create(identity = auth.identity)
      end

      def sign_out
        self.credential = nil
      end

      def credential
        credential = config[:credential]
        credential.respond_to?(:call) ? credential.() : credential
      end

      def credential=(credential)
        config[:credential] = credential
      end

      def exists?
        config.key?(:credential)
      end

      def readonly?
        config.fetch(:readonly, super)
      end

    end
  end
end
