module Authcat
  module Password
    class Plaintext < Abstract

      class << self
        def valid?(password)
          String === password
        end

        def hash(password, **opts)
          password
        end
        
        def rehash(hashed_password, password, **opts)
          password
        end
      end
    end
  end
end
