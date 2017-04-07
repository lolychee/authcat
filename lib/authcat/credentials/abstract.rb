module Authcat
  module Credentials
    class Abstract

      class << self
        def create(identity)
          new.update(identity)
        end

        def valid?(raw_data)
          raise NotImplementedError, '.valid? not implemented.'
        end
      end

      attr_reader :raw_data

      def initialize(raw_data = nil)
        raise_invalid_credential_error unless raw_data.nil? || self.class.valid?(raw_data)
        @raw_data = raw_data
      end

      def update(identity)
        raise_invalid_identity_error unless valid_identity?(identity)
        _update(identity)
        self
      end

      def find
        raise NotImplementedError, '#find not implemented.'
      end

      def to_s
        raw_data
      end
      alias_method :to_str, :to_s

      private

        def _update(identity)
          raise NotImplementedError, '#_update not implemented.'
        end

        def valid_identity?(identity)
          true
        end

        def raise_invalid_credential_error
          raise Errors::InvalidCredential
        end

        def raise_invalid_identity_error
          raise Errors::InvalidIdentity
        end

    end

  end
end
