module Authcat
  module Strategies
    class Session < Base

      option :key, require: true

      def authenticate
        identity = credential.find
        yield identity if identity && block_given?
        identity
      end

      def sign_in(identity = auth.identity)
        self.credential = credential_class.create(identity)
      end

      def sign_out
        clear
      end

      def credential
        credential_class.new(session[key])
      end

      def credential=(credential)
        session[key] = credential.to_s
      end

      def clear
        session.delete(key)
      end

      def session
        request.session
      end

      def exists?
        session.key?(key)
      end

      def readonly?
        false
      end

    end
  end
end
