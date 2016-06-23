module Authcat
  class Password < String
    extend ActiveSupport::Autoload

    include Support::Configurable

    autoload :BCrypt, 'authcat/password/bcrypt'

    SHORT_NAME_MAP = {
      bcrypt: 'BCrypt'
    }.with_indifferent_access

    def self.const_get(name)
      if SHORT_NAME_MAP.key?(name)
        super(SHORT_NAME_MAP[name])
      else
        super
      end
    end

    def self.secure_compare(a, b)
      return false unless a.bytesize == b.bytesize

      result = 0
      a.each_byte.zip(b.each_byte) { |c, d| result |= c ^ d }
      result.zero?
    end

    module ClassMethods
      def create(password, **options)
        new(**options).update(password)
      end

      def verify(hashed_password, password)
        valid?(hashed_password) && new(hashed_password).verify(password)
      end

      def valid?(hashed_password)
        raise NotImplementedError, '.valid? not implemented.'
      end
    end
    extend ClassMethods

    def initialize(hashed_password = nil, **options)
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

    def ==(hashed_password)
      Password.secure_compare(self.to_s, hashed_password.to_s)
    end

    def verify(password)
      self == hash(password.to_s)
    end

    def digest(password)
      dup.update(password)
    end

    private

      def hash(password)
        raise NotImplementedError, '#hash not implemented.'
      end

      class InvalidHash < StandardError; end

  end
end
