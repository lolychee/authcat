module Authcat
  module Strategies
    class Abstract
      extend Forwardable

      include Support::Configurable

      def_delegators :auth, :request, :identity

      option :using

      attr_reader :auth

      def initialize(auth, **options)
        config.merge!(options)
        @auth = auth
      end

      def read
        exists? ? _read : nil
      end

      def read_identity
        read.try(:find)
      end

      def write(credential)
        raise_readonly_error if readonly?
        raise_invalid_credential_error unless valid_credential?(credential)
        _write(credential)
      end

      def write_identity(identity)
        credential = credential_class.create(identity)
        write(credential)
      end

      def clear
        raise_readonly_error if readonly?
        _clear
      end

      def exists?
        false
      end

      def readonly?
        true
      end

      def credential_class
        using
      end

      private

        def valid_credential?(credential)
          credential.class < Credentials::Abstract
        end

        def raise_readonly_error
          raise Errors::StrategyReadonly
        end

        def raise_invalid_credential_error
          raise Errors::InvalidCredential
        end
    end
  end
end
