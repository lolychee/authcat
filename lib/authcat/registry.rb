require 'active_support/hash_with_indifferent_access'

module Authcat
  class Registry < ActiveSupport::HashWithIndifferentAccess

    def register(key, value)
      raise AlreadyExists, "#{key.inspect} already exists." if key?(key)

      self[key] = value
    end

    def lookup(key)
      fetch(key) { raise NotFound, "#{key.inspect} not found." }
    end

    class NotFound < StandardError; end

    class AlreadyExists < StandardError; end
  end
end
