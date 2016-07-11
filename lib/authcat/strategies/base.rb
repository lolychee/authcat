module Authcat
  module Strategies
    class Base
      include Support::Configurable

      option :credential_class, :globalid

      attr_accessor :name

      attr_reader :auth
      delegate :request, to: :auth

      def initialize(auth, **options)
        @auth = auth
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

      def exists?
        false
      end

      def readonly?
        true
      end

    end
  end
end
