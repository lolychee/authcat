module Authcat
  module Strategy
    class Cookies < Abstract
      RACK_COOKIES = "rack.cookies".freeze
      DEFAULT_COOKIES_OPTIONS = {
        httponly: true
      }

      attr_reader :key

      def process(env, authenticator)
        cookie_jar = if env.key?(RACK_COOKIES)
          env[RACK_COOKIES]
        elsif request = ActionDispatch::Request.new(env)
          request.cookie_jar
        end
        return yield unless cookie_jar

        token = cookie_jar[key]
        authenticator.update(name => token) if token

        response = yield

        new_token = authenticator.set_tokens[name]
        cookie_jar[key] = @cookies_options.merge(value: new_token) if new_token
        cookie_jar.delete(key) if authenticator.delete_tokens[name]

        response
      end

      def extract_options(opts)
        @key = opts.fetch(:key) { raise ArgumentError, "option :key required.".freeze }
        @cookies_options = DEFAULT_COOKIES_OPTIONS.merge(opts[:cookies_options] || {})
        super
      end
    end
  end
end
