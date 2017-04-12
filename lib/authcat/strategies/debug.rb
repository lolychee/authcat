module Authcat
  module Strategies
    class Debug < Abstract
      def _read
        @credential ||= config.fetch(:credential)
      end

      def _write(credential)
        @credential = credential
      end

      def _clear
        @credential = nil
      end

      def exists?
        !@credential.nil?
      end

      def readonly?
        config.fetch(:readonly) { super }
      end
    end
  end
end
