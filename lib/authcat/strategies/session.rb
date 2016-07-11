module Authcat
  module Strategies
    class Session < Base

      option :key, required: true

      def credential
        super { parse_credential(session[key]) }
      end

      def credential=(credential)
        session[key] = credential.to_s
        super
      end

      def clear
        session.delete(key)
        super
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
