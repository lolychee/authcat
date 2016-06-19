module Authcat
  module Strategies
    class Session < Base

      option :key

      def self.name
        :session
      end

      def find_credential(request)
        super

        credential = request.session[key]
        credential.nil? ? nil : parse_credential(credential)
      end

      def save_credential(request, credential)
        super

        if credential.nil?
          request.session.delete(key)
        else
          request.session[key] = credential.to_s
        end
      end

      def has_credential?(request)
        super

        !request.session[key].blank?
      end

      def readonly?
        false
      end

      Strategies.register(self.name, self)
    end
  end
end
