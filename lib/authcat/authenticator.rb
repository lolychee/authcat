# frozen_string_literal: true

require "authcat/authenticator/strategies"
require "authcat/authenticator/railtie"

module Authcat
  class Authenticator
    attr_reader :identities

    class << self
      attr_reader :strategies

      def strategy(name, tokenizer, **opts)
        klass = Strategies.lookup(name)
        strategy = klass.new(tokenizer, **opts)
        @strategies ||= {}
        @strategies[strategy.name] = strategy
      end
    end

    def initialize(env)
      @identities = {}
      @env = env
    end

    def [](name)
      @identities[name] ||= self.class.strategies[name].read(@env)
    end

    def []=(name, identity)
      self.class.strategies[name].write(@env, *Array(identity))
      @identities[name] = identity
    end

    def delete(name)
      self.class.strategies[name].delete(@env)
      @identities.delete(name)
    end
  end
end
