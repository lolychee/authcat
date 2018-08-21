module Authcat
  module Strategy
    class Abstract
      attr_reader :app, :finder, :options

      def initialize(app, finder, **opts, &block)
        @app = app
        @finder = finder
        @options = opts

        instance_eval(&block) if block_given?
      end

      def default_name
        raise NotImplementedError, "#default_name not implemented.".freeze
      end

      def default_proc
        @default_proc ||= proc {|finder, token, _| finder.find_by_token(token) }.curry
      end

      def name
        @name ||= options.fetch(:as, default_name)
      end

      def call(env)
        process(env, env[Authenticator::ENV_KEY]) do
          @app.call(env)
        end
      end

      def process(env, authenticator)
        yield
      end
    end
  end
end
