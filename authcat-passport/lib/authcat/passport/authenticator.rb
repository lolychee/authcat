# frozen_string_literal: true

module Authcat
  class Passport
    class Authenticator
      def initialize(app, _opts = {})
        @app = app
        yield if block_given?
      end

      # @return [Array]
      def call(env)
        @app.call(env)
      end
    end
  end
end
