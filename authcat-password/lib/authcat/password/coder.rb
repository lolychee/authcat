module Authcat
  class Password
    class Coder
      def initialize(**opts)
        @opts = opts
      end

      def load(data)
        return if data.nil?

        Password.new(data, **@opts)
      end

      def dump(password)
        return if password.nil?
        if password.is_a?(Password) && password.crypto.is_a?(Crypto::Plaintext)
          password = Password.create(password, **@opts)
        end
        password.to_s
      end
    end
  end
end
