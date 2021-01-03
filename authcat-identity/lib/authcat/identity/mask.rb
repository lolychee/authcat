# frozen_string_literal: true

module Authcat
  module Identity
    class Mask < Module
      DEFAULT_PATTERN = /^.{1}(?<mask>.*).{2}$/.freeze
      DEFAULT_REPLACEMENT = '*'

      # @return [String]
      def initialize(attribute, pattern: DEFAULT_PATTERN, replacement: DEFAULT_REPLACEMENT, &block)
        super()

        define_method("#{attribute}_masked") do
          value = send(attribute).dup
          return if value.nil?

          if block
            block.call(value, pattern: pattern, replacement: replacement)
          else
            m = value.match(pattern)
            m.names.each { |n| value[m.begin(n)...m.end(n)] = replacement * m[n].size }
          end

          value
        end
      end
    end
  end
end
