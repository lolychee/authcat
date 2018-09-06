module Authcat
  module Strategies
    class Session < Abstract
      attr_reader :key

      def process(env, authenticator)
        session = env[Rack::RACK_SESSION]
        return yield unless session

        token = session[key]
        authenticator.update(name => token) if token

        response = yield

        new_token = authenticator.set_tokens[name]
        session[key] = new_token if new_token
        session.delete(key) if authenticator.delete_tokens[name]
        response
      end

      def extract_options(opts)
        @key = opts.fetch(:key) { raise ArgumentError, "option :key required.".freeze }
        super
      end
    end
  end
end
