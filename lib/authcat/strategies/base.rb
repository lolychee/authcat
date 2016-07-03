module Authcat
  module Strategies
    class Base
      include Support::Configurable

      module ClassMethods
        def [](**options)
          Class.new(self) do configure(**options); end
        end
      end
      extend ClassMethods

      option :credential_class, :globalid

      attr_reader :request

      def initialize(request, **options)
        @request = request
        config.merge!(options)
      end

      def authenticate
        raise NotImplementedError, '#authenticate not implemented.'
      end

      def sign_in(*)
        raise NotImplementedError, '#sign_in not implemented.'
      end

      def sign_out
        raise NotImplementedError, '#sign_out not implemented.'
      end

      def credential_class
        case klass = super
        when String, Symbol
          self.credential_class = Credentials.lookup(klass)
        when Array
          type, options = klass
          self.credential_class = Credentials.lookup(type)[**(options || {})]
        else
          klass
        end
      end

      def readonly?
        true
      end

      def present?
        false
      end

    end
  end
end
