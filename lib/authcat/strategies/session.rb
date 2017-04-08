module Authcat
  module Strategies
    class Session < Abstract

      option :key, required: true

      def _read
        credential_class.new(session[key])
      end

      def _write(credential)
        session[key] = credential.to_s
      end

      def _clear
        session.delete(key)
      end

      def session
        request.session
      end

      def exists?
        !session[key].nil?
      end

      def readonly?
        false
      end

    end
  end
end
