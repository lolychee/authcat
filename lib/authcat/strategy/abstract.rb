module Authcat
  module Strategy
    class Abstract
      attr_reader :app, :options

      def initialize(app, credential = Strategy.default_credential, options = {}, &block)
        @app = app
        @credential = credential
        @options = options

        instance_eval(&block) if block_given?
      end

      def call(env)
       @app.call(env)
      end
    end
  end
end
