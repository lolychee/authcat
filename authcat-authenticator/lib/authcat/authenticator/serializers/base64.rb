# frozen_string_literal: true

require "base64"

module Authcat
  module Authenticator
    module Serializers
      class Base64
        def initialize; end

        def encode(value)
          ::Base64.urlsafe_encode64(value)
        end

        def decode(value)
          ::Base64.urlsafe_decode64(value)
        end
      end
    end
  end
end
