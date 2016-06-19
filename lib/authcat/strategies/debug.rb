module Authcat
  module Strategies
    class Debug < Base

      def self.name
        :debug
      end

      def read_credential(request)
        credential = config.credential
        credential.respond_to?(:call) ? credential.call(self) : credential
      end

      def write_credential(request, credential)
        config.credential = credential
      end

      def has_credential?(request)
        config.key?(:credential)
      end

      def readonly?
        config.fetch(:readonly, super)
      end

      def credential_class
        config.credential_class || super
      end

      Strategies.register(self.name, self)
    end
  end
end
