module Authcat
  module Support
    class Registry
      extend Forwardable
      include Enumerable

      def_delegators :@hash, :empty?, :key?, :each, :to_hash

      def initialize(*args, &block)
        @hash = Hash.new(*args, &block)
      end

      def []=(key, value)
        raise AlreadyExists, "#{key.inspect} already exists" if @hash.key?(key)
        @hash.store(key, value)
      end
      alias_method :register, :[]=

      def [](key)
        @hash.fetch(key) { raise NotFound, "Not found #{key.inspect}" }
      end
      alias_method :lookup, :[]

      class NotFound < StandardError; end
      class AlreadyExists < StandardError; end

    end
  end
end
