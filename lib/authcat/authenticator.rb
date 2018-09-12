# frozen_string_literal: true

module Authcat
  class Authenticator
    include Enumerable

    ENV_KEY = "authcat.authenticator"

    attr_reader :identities, :set_identities, :delete_identities

    def initialize(&block)
      @identities = {}
      @set_identities = {}
      @delete_identities = {}
    end

    def update(other_hash)
      @identities.update(Hash[other_hash.map { |k, v| [k.to_sym, v] }])
    end

    def [](name)
      @identities[name.to_sym]
    end

    def []=(name, identity)
      @identities[name.to_sym] = identity
      @set_identities[name.to_sym] = identity
    end

    def delete(name)
      @identities.delete(name.to_sym)
      @delete_identities[name.to_sym] = true
    end
  end
end
