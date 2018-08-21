module Authcat
  module Strategy
    class Cookies < Abstract
      RACK_COOKIES = "rack.cookies".freeze

      def default_name
        :cookies
      end

      def key
        @key ||= options.fetch(:key) { raise ArgumentError, "option :key required.".freeze }
      end

      def process(env, authenticator)
        cookie_jar = if env.key?(RACK_COOKIES)
          env[RACK_COOKIES]
        elsif request = ActionDispatch::Request.new(env)
          request.cookie_jar
        end

        if cookie_jar.key?(key)
          token = cookie_jar[key]
          authenticator[name] = default_proc[finder, token]
        end

        yield
      end
    end
  end
end
