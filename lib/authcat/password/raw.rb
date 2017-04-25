module Authcat
  module Password
    class Raw < Base
      class << self
        def valid?(*)
          true
        end
      end

      def hash_function(password)
        password
      end
    end
  end
end
