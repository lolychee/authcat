module Authcat
  module Strategies
    class Base
      include Support::Configurable

      option :credential_type, :globalid
      option :credential_options
      self.credential_options = {}

      attr_accessor :name

      attr_reader :auth
      delegate :request, to: :auth

      def initialize(auth, **options)
        @auth = auth
        config.merge!(options)
      end

      def authenticate
        identity = credential.find
        yield identity if identity && block_given?
        identity
      end

      def sign_in(identity = auth.identity)
        self.credential = create_credential(identity)
        identity
      end

      def sign_out
        clear
      end

      def credential
        @credential = yield if block_given?
        @credential
      end

      def credential=(credential)
        @credential = credential
      end

      def clear
        @credential = nil
      end

      def create_credential(identity)
        if identity.respond_to?(:to_credential)
          identity.to_credential(credential_type, **credential_options)
        else
          Authcat::Credentials.create(credential_type, identity, **credential_options)
        end
      end

      def parse_credential(credential)
        Authcat::Credentials.parse(credential_type, credential, **credential_options)
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
