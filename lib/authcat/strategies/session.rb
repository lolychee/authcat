# frozen_string_literal: true

module Authcat
  module Strategies
    class Session < Abstract
      attr_reader :key

      def process(env, authenticator)
        session = env[Rack::RACK_SESSION]
        return yield unless session

        # read
        token = session[key]
        authenticator.update(name => tokenizer.untokenize(token)) if token

        response = yield

        # write
        new_identity, opts = Array(authenticator.set_identities[name])
        if new_identity
          session[key] = tokenizer.tokenize(new_identity)
        end

        # delete
        session.delete(key) if authenticator.delete_identities[name]

        response
      end

      def extract_options(opts)
        @key = opts.fetch(:key) { raise ArgumentError, "option :key required." }
        super
      end
    end
  end
end
