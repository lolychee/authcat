# frozen_string_literal: true

module Authcat
  module Password
    module Algorithms
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
          Utils.secure_compare(@hashed_password, self.class.hash(password, **@options))
        end
        alias == verify

        def to_s
          @hashed_password.to_s
        end
        alias to_str to_s
      end
    end
  end
end
