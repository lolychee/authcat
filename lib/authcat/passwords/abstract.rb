# frozen_string_literal: true

module Authcat
  module Passwords
    # TODO 与 Digest 接口保持统一
    # TODO 增加 HMAC 支持
    # TODO 支持 argon2 算法
    class Abstract
      class << self
        def valid?(password)
          raise NotImplementedError, ".valid? not implemented."
        end

        def hash(password, **opts)
          raise NotImplementedError, ".hash not implemented."
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
        Passwords.secure_compare(@hashed_password, self.class.hash(password, **@options))
      end

      def to_s
        @hashed_password.to_s
      end
      alias_method :to_str, :to_s
    end
  end
end
