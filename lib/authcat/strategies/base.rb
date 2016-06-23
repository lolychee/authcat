module Authcat
  module Strategies
    class Base
      include Support::Configurable

      def initialize(**options)
        config.merge!(options)
      end

      def find_credential(request)
        raise NotImplementedError, '#find_credential not implemented.'
      end

      def save_credential(request, credential)
        raise NotImplementedError, '#save_credential not implemented.'
      end

      def has_credential?(request)
        raise NotImplementedError, '#has_credential? not implemented.'
      end

      def find_user(request)
        find_credential(request).try(:find_user)
      end

      def save_user(request, user)
        if user.nil?
          save_credential(request, nil)
        else
          save_credential(request, generate_credential(user))
        end
      end

      def parse_credential(credential)
        Credentials::GlobalID.new(credential)
      rescue Credentials::InvalidCredential
        nil
      end

      def generate_credential(user)
        Credentials::GlobalID.create(user)
      end

      def readonly?
        true
      end

    end
  end
end
