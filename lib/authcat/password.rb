module Authcat
  class Password < String
    extend ActiveSupport::Autoload

    extend Support::Registrable
    include Support::Configurable

    eager_autoload do
      autoload :BCrypt, 'authcat/password/bcrypt'
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
        raise NotImplementedError, '.valid? not implemented.'
      end
    end

    def self.secure_compare(a, b)
      return false unless a.bytesize == b.bytesize

      result = 0
      a.each_byte.zip(b.each_byte) { |c, d| result |= c ^ d }
      result == 0
    end

    def self.inherited(subclass)
      subclass.extend ClassMethods
    end

    def initialize(hashed_password = nil, **options)
      raise 'this is an abstract class.' if self === Authcat::Password

      config.merge!(options)

      if hashed_password
        replace(hashed_password)
      else
        update('')
      end
    end

    def replace(hashed_password)
      raise InvalidHash, "invalid hash: #{hashed_password.inspect}." unless self.class.valid?(hashed_password)
      super
    end

    def update(password)
      replace(hash(password.to_s))
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

    private

      def hash(password)
        raise NotImplementedError, '#hash not implemented.'
      end

      class InvalidHash < StandardError; end

      eager_load!
  end
end
