# frozen_string_literal: true

module Authcat
  module Supports
    module Registrable
      def registry
        @registry ||= Hash.new { |_, name| raise NameError, "Unknown #{name.inspect}" }
      end

      def register(name, value)
        registry[name] = value
      end

      def lookup(name)
        registry[name]
      end
    end
  end
end
