module Authcat
  module Strategy
    class Session < Abstract
      def default_name
        :session
      end

      def key
        @key ||= options.fetch(:key) { raise ArgumentError, "option :key required.".freeze }
      end

      def process(env, authenticator)
        session = env[Rack::RACK_SESSION]

        if session.key?(key)
          token = session[key]
          authenticator[name] = default_proc[finder, token]
        end

        yield
      end
    end
  end
end
