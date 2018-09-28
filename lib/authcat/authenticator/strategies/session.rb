# frozen_string_literal: true

module Authcat
  class Authenticator
    module Strategies
      class Session < Abstract
        attr_reader :key

        def read(env, **opts)
          return unless session = fetch_session(env)

          tokenizer.untokenize(session[key]) if session.key?(key)
        end

        def write(env, identity, opts = {})
          return unless session = fetch_session(env)

          session[key] = tokenizer.tokenize(identity)
        end

        def delete(env)
          return unless session = fetch_session(env)

          session.delete(key)
        end

        def fetch_session(env)
          env[Rack::RACK_SESSION]
        end

        def extract_options(opts)
          @key = opts.fetch(:key) { raise ArgumentError, "option :key required." }
          super
        end
      end
    end
  end
end
