# frozen_string_literal: true

require "authcat/passwords/abstract"
require "authcat/passwords/plaintext"
require "authcat/passwords/bcrypt"

module Authcat
  module Passwords
    extend Supports::Registrable

    register :plaintext, Plaintext
    register :bcrypt,    BCrypt

    class << self
      def secure_compare(a, b)
        return false unless a.bytesize == b.bytesize

        a.each_byte.zip(b.each_byte).map { |a, b| a ^ b }.reduce(:|).zero?
      end
    end
  end
end
