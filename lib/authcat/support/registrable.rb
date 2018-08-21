module Authcat
  module Support
    module Registrable
      def registry
        @registry ||= Hash.new
      end

      def register(key, value)
        registry[key] = value
      end
      
      def lookup(key)
        return key if key.is_a?(Class)
        class_name = registry[key]
        class_name.is_a?(Class) ? class_name : const_get(class_name)
      end
    end
  end
end
