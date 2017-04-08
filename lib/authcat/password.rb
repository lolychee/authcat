module Authcat
  module Password
    extend ActiveSupport::Autoload

    extend Support::Registrable

    autoload :Base
    autoload :BCrypt, 'authcat/password/bcrypt'

    register :bcrypt, :BCrypt

    def self.lookup(name)
      super do |value|
        value.is_a?(Class) ? value : const_get(value)
      end
    end

    def self.secure_compare(a, b)
      return false unless a.bytesize == b.bytesize

      a.each_byte.zip(b.each_byte).lazy.map {|a, b| a ^ b }.reduce(:|).zero?
    end

  end
end
