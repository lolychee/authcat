# frozen_string_literal: true

module Authcat
  module Authenticator
    module Providers
      class HttpHeader < Abstract
        def initialize(**options)
          @options = options
        end

        def add_header(name, value)
          @headers[name] = value
        end

        def get_header(name)
          @headers[name]
        end

        def remove_header(name)
          @headers.delete(name)
        end
      end
    end
  end
end
