module Authcat
  module Passwords
    extend Support::Registrable

    class << self
      def secure_compare(a, b)
        return false unless a.bytesize == b.bytesize

        a.each_byte.zip(b.each_byte).map { |a, b| a ^ b }.reduce(:|).zero?
      end
    end
  end
end

require "authcat/passwords/abstract"
require "authcat/passwords/plaintext"
require "authcat/passwords/bcrypt"
