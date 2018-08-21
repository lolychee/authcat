module Authcat
  module Locator
    class Abstract
      attr_reader :options

      def initialize(**opts)
        @options = opts
      end

      def find(location)
        raise NotImplementedError, "#find not implemented."
      end

      def to_location(identity)
        raise NotImplementedError, "#to_location not implemented."
      end
    end
  end
end
