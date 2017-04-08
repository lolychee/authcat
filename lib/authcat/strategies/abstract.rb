module Authcat
  module Strategies
    class Abstract

      include Support::Configurable

      option :using

      attr_reader :auth
      delegate :request, :identity, to: :auth

      def initialize(auth, **options)
        config.merge!(options)
        @auth = auth
      end

      def read
        exists? ? _read : nil
      end

      def write(credential)
        raise_readonly_error if readonly?
        raise_invalid_credential_error unless valid_credential?(credential)
        _write(credential)
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
