module Authcat
  module Password
    def self.Plaintext(hashed_password)
      Plaintext.new(hashed_password)
    end

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
