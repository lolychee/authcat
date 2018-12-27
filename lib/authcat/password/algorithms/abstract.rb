# frozen_string_literal: true

module Authcat
  module Password
    module Algorithms
      class Abstract
        class << self
          def valid?(password)
            raise NotImplementedError, ".valid? not implemented."
          end

          def __hash__(password, **opts)
            raise NotImplementedError, ".hash not implemented."
          end
        end

        def initialize(hashed_password = nil, **opts)
          @init_options = opts
          reset(hashed_password)
        end

        def new(hashed_password = nil)
          clone.reset(hashed_password)
        end

        def reset(hashed_password = nil)
          @options = @init_options.dup
          if hashed_password.nil? || hashed_password.is_a?(Plaintext)
            update(hashed_password)
          else
            raise ArgumentError, "invalid hash: #{hashed_password.inspect}" unless valid?(hashed_password)
            self.hashed_password = hashed_password.to_s
          end

          self
        end

        def update(password)
          self.hashed_password = self.class.__hash__(password.to_s, **@options)
        end
        alias << update

        def valid?(hashed_password)
          self.class.valid?(hashed_password)
        end

        def verify(password)
          Utils.secure_compare(@hashed_password, self.class.__hash__(password, **@options))
        end
        alias == verify

        def to_s
          @hashed_password.to_s
        end
        alias to_str to_s

        private

          attr_writer :hashed_password
      end
    end
  end
end
