module Authcat
  class Registry

    def initialize(type = Object)
      @type = type
      @registry = ActiveSupport::OrderedOptions.new
    end

    def []=(key, value)
      raise AlreadyExists, "#{key.inspect} already exist." if @registry.key?(key)
      raise TypeError, "#{value.inspect} is not #{@type}." unless value.is_a?(@type)

      @registry[key] = value
    end
    alias_method :register, :[]=

    def [](key)
      @registry.fetch(key) { raise NotFound, "#{key.inspect} not found." }
    end
    alias_method :lookup, :[]

    def to_s
      @registry.to_s
    end

    class NotFound < StandardError
    end

    class AlreadyExists < StandardError
    end

    class TypeError < StandardError
    end

  end
end
