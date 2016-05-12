require 'active_support/ordered_options'

module Authcat
  module Providers
    class SimpleSessionProvider < Provider

      option :session_name, reader: true

      def get_auth_hash(request, **options)
        encoded = request.session[session_name]
        decode_auth_hash(encoded)
      rescue
        nil
      end

      def set_auth_hash(request, auth_hash, **options)
        request.session[session_name] = encode_auth_hash(auth_hash)
      rescue
        false
      end

      private

        def encode_auth_hash(auth_hash)
          auth_hash.to_json
        end

        def decode_auth_hash(encoded)
          Authcat::AuthHash.new(JSON.parse(encoded))
        end

    end
  end
end
