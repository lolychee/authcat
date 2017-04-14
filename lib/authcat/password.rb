module Authcat
  module Password
    extend ActiveSupport::Autoload

    autoload :Base
    autoload :BCrypt, "authcat/password/bcrypt"

    extend Support::Registrable
    has_registry

    extend SingleForwardable
    def_delegators :registry, :register, :lookup

    register :bcrypt, Password::BCrypt

    def self.secure_compare(a, b)
      return false unless a.bytesize == b.bytesize

      a.each_byte.zip(b.each_byte).lazy.map { |a, b| a ^ b }.reduce(:|).zero?
    end
  end
end
