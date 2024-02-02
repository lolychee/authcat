# frozen_string_literal: true

require "authcat/support"

module Authcat
  module Authenticator
    module Serializers
      include Authcat::Support::ActsAsRegistry

      register(:base64) { Base64 }
      register(:jwt) { JWT }

      def serializers
        @serializers ||= {}
      end

      def serializer(name, *, **, &)
        klass = Serializers.resolve(name)
        serializers[name] = klass.new(*, **, &)
      end
    end
  end
end
