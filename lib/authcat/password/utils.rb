# frozen_string_literal: true

module Authcat
  module Password
    module Utils
      extend self

      def secure_compare(a, b)
        a.bytesize == b.bytesize &&
        a.each_byte.zip(b.each_byte).map { |a, b| a ^ b }.reduce(:|).zero?
      end
    end
  end
end
