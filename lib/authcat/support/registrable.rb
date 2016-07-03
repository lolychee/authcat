module Authcat
  module Support
    module Registrable

      class Registry
        def initialize
          @hash = {}
        end

        def register(key, value)
          raise ArgumentError, "key #{key.inspect} already exists" if @hash.key?(key)
          yield(value) if block_given?
          @hash.store(key, value)
        end

        def lookup(key)
          value = @hash.fetch(key) { raise ArgumentError, "Unknown key #{key.inspect}" }
          block_given? ? yield(value) : value
        end
      end

      def registry
        @registry ||= Registry.new
      end

      def register(key, value, **options, &block)
        registry.register(key, value, &block)
      end

      def lookup(key, **options, &block)
        registry.lookup(key, &block)
      end
    end
  end
end
