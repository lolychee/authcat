module Authcat
  module Support
    module Registrable
      class Registry
        include Enumerable

        def initialize(*args, reader: nil, writer: nil, &block)
          @reader = reader
          @writer = writer
          @hash = Hash.new(*args, &block)
        end

        def []=(key, value)
          raise AlreadyExists, "#{key.inspect} already exists" if @hash.key?(key)
          value = @writer.call(value) if @writer.respond_to?(:call)
          @hash.store(key, value)
        end
        alias_method :register, :[]=

        def [](key)
          value = @hash.fetch(key) { raise NotFound, "Not found #{key.inspect}" }
          @reader.respond_to?(:call) ? @reader.call(value) : value
        end
        alias_method :lookup, :[]

        def method_missing(method_name, *args, &block)
          if @hash.respond_to?(method_name)
            @hash.send(method_name, *args, &block)
          else
            super
          end
        end

        class NotFound < StandardError; end
        class AlreadyExists < StandardError; end
      end

      def has_registry(name = :registry, **options)
        iv_name = "@#{name}"
        define_singleton_method(name) do
          instance_variable_get(iv_name) || instance_variable_set(iv_name, ::Authcat::Support::Registrable::Registry.new(**options))
        end
      end

      # def registry
      #   @registry ||= Registry.new
      # end
      #
      # def register(key, value, **options, &block)
      #   registry.register(key, value, &block)
      # end
      #
      # def lookup(key, **options, &block)
      #   registry.lookup(key, &block)
      # end
    end
  end
end
