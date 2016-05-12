module Authcat
  class Digest

    class << self
      def lookup(name)
        const_get(name, false)
      end

      def secure_compare(a, b)
        return false unless a.bytesize == b.bytesize

        l = a.bytes

        b.each_byte.reduce(0) { |res, byte| res |= byte ^ l.shift } == 0
      end

      def inherited(subclass)
        subclass.include Authcat::Options::Optionable
        subclass.extend ClassMethods
      end
    end

    module ClassMethods
      def digest(password, **options)
        new(**options).update(password)
      end

      def compare(hashed_password, password)
        return false if hashed_password.blank?

        new(hashed_password).compare(password)
      end

      def valid?(hashed_password)
        raise 'not implemented'
      end
    end

    def initialize(hashed_password = nil, **options)
      raise 'this is an abstract class.' if self === Authcat::Digest

      apply_options(options)
      replace(hashed_password) if hashed_password
    end

    def replace(hashed_password)
      raise Errors::InvalidHash unless self.class.valid?(hashed_password)
      @hashed_password = hashed_password
    end

    def digest(password)
      self.class.new(_hash(password), **options)
    end

    def update(password)
      replace(_hash(password))
    end
    alias_method :<<, :update

    def ==(password)
      case password
      when String, Authcat::Digest::BCrypt
        Digest.secure_compare(to_s, _hash(password.to_s))
      else
        super
      end
    end
    alias_method :compare, :==

    def to_s
      @hashed_password
    end

    private

      def _hash(password)
        raise 'not implemented'
      end

  end
end

require 'authcat/digest/errors'
require 'authcat/digest/bcrypt'
