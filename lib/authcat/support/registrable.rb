require 'active_support/hash_with_indifferent_access'

module Authcat
  module Support
    module Registrable

      def registry
        @registry ||= Registry.new
      end

      def lookup(*args)
        registry.lookup(*args)
      end

      def register(*args)
        registry.register(*args)
      end

    end
  end
end
