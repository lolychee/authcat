# frozen_string_literal: true

module Authcat
  module Authenticator
    module Providers
      class Cookie < Abstract
        # COOKIE_OPTION_KEYS = %i[domain expires httponly partitioned path same_site secure].freeze

        attr_reader :key, :options

        def initialize(app, key:, **options)
          super

          @key = key
          @options = options
        end

        def call(env)
          request = build_request(env)

          status, headers, body = call_app(request.env)

          response = build_response(status, headers, body)

          response.finish
        end
      end
    end
  end
end
