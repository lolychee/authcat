module Authcat
  module Strategies
    class Debug < Base

      def find_credential(request)
        credential.respond_to?(:call) ? credential.call(self) : credential
      end

      def save_credential(request, credential)
        self.credential = credential
      end

      def has_credential?(request)
        config.key?(:credential)
      end

      def readonly?
        config.fetch(:readonly, super)
      end

    end
  end
end
