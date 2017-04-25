module Authcat
  module Password
    extend ActiveSupport::Autoload

    autoload :Base
    autoload :Raw
    autoload :BCrypt, "authcat/password/bcrypt"

    extend Support::Registrable
    has_registry

    extend SingleForwardable
    def_delegators :registry, :register, :lookup

    register :bcrypt, Password::BCrypt

    cattr_accessor :default_method
    self.default_method = :bcrypt

    class << self
      def secure_compare(a, b)
        return false unless a.bytesize == b.bytesize

        a.each_byte.lazy.zip(b.each_byte).map { |a, b| a ^ b }.reduce(:|).zero?
      end

      def create(raw_password, method: default_method, **options)
        lookup(method).create(raw_password, **options)
      end

      def parse(digest_password, method: default_method, **options)
        lookup(method).parse(digest_password, **options)
      end

      def valid?(digest_password, method: default_method, **options)
        lookup(method).valid?(digest_password, **options)
      end
    end
  end
end
