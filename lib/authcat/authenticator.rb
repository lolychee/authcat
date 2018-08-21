module Authcat
  class Authenticator
    ENV_KEY = "authcat.authenticator".freeze

    def initialize(app, &block)
      @builder = Rack::Builder.new(app)
      @strategies = Hash.new {|_, key| raise ArgumentError, "unknown strategy: #{key.inspect}.".freeze }
      @lazy = Hash.new
      instance_eval(&block) if block_given?

      @app = @builder.to_app
    end

    def call(env)
      dup._call(env)
    end

    def _call(env)
      env[ENV_KEY] = self
      @app.call(env)
    end

    def strategy(name, finder, **opts)
      strategy = Strategy.lookup(name)
      @builder.use strategy, finder, **opts
    end

    def []=(key, value)
      @lazy[key] = value.is_a?(Proc) ? value : proc { value }
    end

    def [](key)
      proc = @lazy[key]
      proc && proc[self]
    end
  end
end
