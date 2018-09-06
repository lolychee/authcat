# frozen_string_literal: true

module Authcat
  class Middleware
    def initialize(app, &block)
      @builder = Rack::Builder.new(app)
      # @strategies = Hash.new {|_, key| raise ArgumentError, "unknown strategy: #{key.inspect}." }

      instance_eval(&block) if block_given?

      @app = @builder.to_app
    end

    def call(env)
      @app.call(env)
    end

    def strategy(name, tokenizer, **opts)
      strategy = Strategies.lookup(name)
      @builder.use strategy, tokenizer, **opts
    end
  end
end
