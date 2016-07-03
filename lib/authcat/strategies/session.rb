module Authcat
  module Strategies
    class Session < Base

      option :key, require: true

      def authenticate
        if user = credential.find
          throw :success, user
        end
      end

      def sign_in(user, params = {})
        self.credential = credential_class.create(user, params)
      end

      def sign_out
        clear_credential!
      end

      def credential
        credential_class.new(session[key])
      end

      def credential=(credential)
        session[key] = credential.to_s
      end

      def clear_credential!
        session.delete(key)
      end

      def session
        request.session
      end

      def present?
        session.key?(key)
      end

      def readonly?
        false
      end

    end
  end
end
