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

        def initialize(password_digest = nil, **opts)
          @init_options = opts
          reset(password_digest)
        end

        def new(password_digest = nil)
          clone.reset(password_digest)
        end

        def reset(password_digest = nil)
          @options = @init_options.dup
          if password_digest.nil? || password_digest.is_a?(Plaintext)
            update(password_digest.to_s)
          else
            raise ArgumentError, "invalid hash: #{password_digest.inspect}" unless valid?(password_digest)
            self.password_digest = password_digest.to_s
          end

          self
        end

        def update(password)
          self.password_digest = self.class.__hash__(password, **@options)
        end
        alias << update

        def valid?(password_digest)
          self.class.valid?(password_digest, **@options)
        end

        def verify(password)
          Utils.secure_compare(@password_digest, password) || Utils.secure_compare(@password_digest, self.class.__hash__(password, **@options))
        end
        alias == verify

        def to_s
          @password_digest
        end
        alias to_str to_s

        private

          attr_writer :password_digest
      end
    end
  end
end
