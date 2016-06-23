module Authcat
  module Strategies
    class Session < Base

      option :key

      def find_credential(request)
        parse_credential(request.session[key])
      end

      def save_credential(request, credential)
        if credential.nil?
          request.session.delete(key)
        else
          raise ArgumentError, "credential should be Authcat::Credentials::Base instance" unless credential.is_a?(Authcat::Credentials::Base)
          request.session[key] = credential.to_s
        end
      end

      def has_credential?(request)
        request.session.key?(key)
      end

      def readonly?
        false
      end

    end
  end
end
