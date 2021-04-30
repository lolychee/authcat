# frozen_string_literal: true

module Authcat
  module Identifier
    module Mask
      DEFAULT_PATTERN = /^.{1}(?<mask>.*).{2}$/.freeze

      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        def mask(attribute, pattern: DEFAULT_PATTERN, replacement: '*', &block)
          include InstanceMethodsOnActivation.new(attribute, pattern: pattern, replacement: replacement, &block)
        end
      end

      class InstanceMethodsOnActivation < Module
        # @return [String]
        def initialize(attribute, pattern:, replacement:, &block)
          super()

          define_method("#{attribute}_masked") do
            value = send(attribute).dup
            return if value.nil?

            if block
              block.call(value, pattern: pattern, replacement: replacement)
            else
              m = value.match(pattern)
              m&.names.each { |n| value[m.begin(n)...m.end(n)] = replacement * m[n].size }
              value
            end
          end
        end
      end
    end
  end
end
