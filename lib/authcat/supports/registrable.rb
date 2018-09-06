module Authcat
  module Supports
    module Registrable
      def registry
        @registry ||= Hash.new
      end

      def register(key, value)
        registry[key] = value
      end

      def lookup(key)
        registry.fetch(key) {|name| raise NameError, "Unknown #{name.inspect}" }
       end
    end
  end
end
