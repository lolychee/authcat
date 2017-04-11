module Authcat
  module Credentials
    class Abstract

      class << self
        def create(identity)
          new.update(identity)
        end

        def parse(raw_data)
          raise Errors::InvalidCredential unless valid?(raw_data)
          new(raw_data)
        end

        def valid?(raw_data)
          raise NotImplementedError, '.valid? not implemented.'
        end
      end

      attr_reader :raw_data, :identity

      def initialize(raw_data = nil)
        @raw_data = raw_data
      end

      def valid?
        self.class.valid?(raw_data)
      end

      def update(identity)
        raise_invalid_identity_error unless valid_identity?(identity)
        _update(identity)
        @identity = identity
        self
      end

      def find
        @identity = _find
      end

      def to_s
        raw_data
      end
      alias_method :to_str, :to_s

      private

        def _update(identity)
          raise NotImplementedError, '#_update not implemented.'
        end

        def _find
          raise NotImplementedError, '#_find not implemented.'
        end

        def valid_identity?(identity)
          true
        end

        def raise_invalid_identity_error
          raise Errors::InvalidIdentity
        end

    end

  end
end
