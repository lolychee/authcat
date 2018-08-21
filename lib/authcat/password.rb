module Authcat
  module Password
    extend ActiveSupport::Autoload
    extend Support::Registrable

    autoload :Abstract
    autoload :Plaintext
    autoload :BCrypt, "authcat/password/bcrypt"

    register :plaintext,  :Plaintext
    register :bcrypt,     :BCrypt

    class << self
      def secure_compare(a, b)
        return false unless a.bytesize == b.bytesize

        a.each_byte.zip(b.each_byte).map { |a, b| a ^ b }.reduce(:|).zero?
      end
    end
  end
end
