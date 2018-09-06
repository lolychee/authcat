module Authcat
  module Strategy
    class Abstract
      attr_reader :app, :tokenizer, :options
      attr_reader :name

      class << self
        def default_name
          @default_name ||= to_s.split("::").last.downcase
        end
      end

      def initialize(app, tokenizer, **opts, &block)
        @app = app
        @tokenizer = tokenizer
        @options = extract_options(opts)

        instance_eval(&block) if block_given?
      end

      def call(env)
        authenticator = env[Authenticator::ENV_KEY] ||= Authenticator.new

        authenticator.use(name, tokenizer)

        process(env, authenticator) do
          @app.call(env)
        end
      end

      def process(env, authenticator)
        yield
      end

      def extract_options(opts)
        @name ||= opts.fetch(:as, self.class.default_name).to_sym
        opts
      end
    end
  end
end
