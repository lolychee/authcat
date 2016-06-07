module Authcat
  class Password < String
    extend ActiveSupport::Autoload

    eager_autoload do
      autoload :BCrypt, 'authcat/password/bcrypt'
    end

    class << self

      def registry
        @registry ||= Registry.new
      end

      delegate :register, :lookup, to: :registry

      def secure_compare(a, b)
        return false unless a.bytesize == b.bytesize

        result = 0
        a.each_byte.zip(b.each_byte) { |c, d| result |= c ^ d }
        result == 0
      end

      def inherited(subclass)
        subclass.include Authcat::Options::Optionable
        subclass.extend ClassMethods
      end
    end

    module ClassMethods
      def create(password, **options)
        new(**options).update(password)
      end

      def verify(hashed_password, password)
        return false if hashed_password.blank?

        new(hashed_password).verify(password)
      end

      def valid?(hashed_password)
        raise NotImplementedError, 'not implemented'
      end
    end

    def initialize(hashed_password = nil, **options)
      raise 'this is an abstract class.' if self === Authcat::Password

      apply_options(options)

      if hashed_password
        replace(hashed_password)
      else
        update('')
      end
    end

    def replace(hashed_password)
      raise InvalidHash, "invalid hash: #{hashed_password}" unless self.class.valid?(hashed_password)
      super
    end

    def update(password)
      replace(hash(password))
    end
    alias_method :<<, :update

    def ==(password)
      Password.secure_compare(self.to_s, password.to_s)
    end

    def verify(password)
      Password.secure_compare(self.to_s, hash(password.to_s))
    end

    def digest(password)
      self.class.new(hash(password.to_s), **options)
    end

    class InvalidHash < StandardError
    end

    private

      def hash(password)
        raise NotImplementedError, 'not implemented'
      end

      eager_load!
  end
end
