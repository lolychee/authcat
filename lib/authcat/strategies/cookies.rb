# frozen_string_literal: true

module Authcat
  module Strategies
    class Cookies < Abstract
      RACK_COOKIES = "rack.cookies"
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
        authenticator.update(name => tokenizer.untokenize(token)) if token

        response = yield

        new_identity, opts = Array(authenticator.set_identities[name])
        if new_identity
          cookie_hash = @cookies_options.merge(opts)
          cookie_hash[:value] = tokenizer.tokenize(new_identity)
          cookie_jar[key] = cookie_hash
        end

        cookie_jar.delete(key) if authenticator.delete_identities[name]

        response
      end

      def extract_options(opts)
        @key = opts.fetch(:key) { raise ArgumentError, "option :key required." }
        @cookies_options = DEFAULT_COOKIES_OPTIONS.merge(opts[:cookies_options] || {})
        super
      end
    end
  end
end
