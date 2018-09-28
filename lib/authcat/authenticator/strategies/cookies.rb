# frozen_string_literal: true

module Authcat
  class Authenticator
    module Strategies
      class Cookies < Abstract
        RACK_COOKIES = "rack.cookies"
        DEFAULT_COOKIES_OPTIONS = {
          httponly: true
        }

        attr_reader :key

        def read(env, **opts)
          return unless cookie_jar = fetch_cookie_jar(env)

          tokenizer.untokenize(cookie_jar[key]) if cookie_jar.key?(key)
        end

        def write(env, identity, opts = {})
          return unless cookie_jar = fetch_cookie_jar(env)

          cookie_jar[key] = @cookies_options.merge(value: tokenizer.tokenize(identity), **opts)
        end

        def delete(env)
          return unless cookie_jar = fetch_cookie_jar(env)

          cookie_jar.delete(key)
        end

        def fetch_cookie_jar(env)
          if env.key?(RACK_COOKIES)
            env[RACK_COOKIES]
          elsif request = ActionDispatch::Request.new(env)
            request.cookie_jar
          end
        end

        def extract_options(opts)
          @key = opts.fetch(:key) { raise ArgumentError, "option :key required." }
          @cookies_options = DEFAULT_COOKIES_OPTIONS.merge(opts[:cookies_options] || {})
          super
        end
      end
    end
  end
end
