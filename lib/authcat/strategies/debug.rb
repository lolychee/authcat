module Authcat
  module Strategies
    class Debug < Base

      def authenticate
        if user = credential.find
          throw :success, user
        end
      end

      def sign_in(user)
        self.credential = credential_class.create(user)
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

      def present?
        config.key?(:credential)
      end

      def readonly?
        config.fetch(:readonly, super)
      end

    end
  end
end
