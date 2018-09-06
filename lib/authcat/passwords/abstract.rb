# frozen_string_literal: true

module Authcat
  module Passwords
    class Abstract
      class << self
        def valid?(password)
          raise NotImplementedError, ".valid? not implemented."
        end

        def hash(password, **opts)
          raise NotImplementedError, ".hash not implemented."
        end

        def rehash(hashed_password, password, **opts)
          raise NotImplementedError, ".rehash not implemented."
        end
      end

      def initialize(hashed_password = nil, **opts)
        @options = opts
        @hashed_password = if block_given?
          self.class.hash(yield, opts)
        else
          raise ArgumentError, "invalid hash: #{hashed_password.inspect}" unless self.class.valid?(hashed_password)
          hashed_password
        end
      end

      def verify(password)
        Password.secure_compare(@hashed_password, self.class.rehash(@hashed_password, password, **@options))
      end

      def to_s
        @hashed_password
      end
      alias_method :to_str, :to_s

      def inspect
        "#{self.class}(#{to_s.inspect})"
      end
    end
  end
end
