module Authcat
  module Password
    class Plaintext < Base
      class << self
        def valid?(password)
          String === password
        end
      end

      def hash_function(password)
        password
      end
    end
  end
end
