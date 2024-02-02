# frozen_string_literal: true

require "dry/transformer"

module Authcat
  module Authenticator
    module Providers
      class Abstract
        attr_reader :request_pipeline, :response_pipeline

        def initialize(app, *, **, &)
          @app = app
        end

        def call_app(env)
          @app.call(env)
        end

        def build_request(env)
          Rack::Request.new(env)
        end

        def build_response(status, headers, body)
          Rack::Response.new(body, status, headers)
        end
      end
    end
  end
end
