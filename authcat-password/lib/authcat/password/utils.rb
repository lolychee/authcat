# frozen_string_literal: true

module Authcat
  class Password
    module Utils
      module_function

      # @return [Boolean]
      def secure_compare(a, b)
        a = a.to_s
        b = b.to_s
        a.bytesize == b.bytesize &&
          a.each_byte.zip(b.each_byte).map { |a, b| a ^ b }.reduce(:|).zero?
      end
    end
  end
end
