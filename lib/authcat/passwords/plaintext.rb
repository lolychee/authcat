# frozen_string_literal: true

module Authcat
  module Passwords
    class Plaintext < Abstract
      class << self
        def valid?(password)
          password.is_a?(String)
        end

        def hash(password, **opts)
          password
        end

        def rehash(hashed_password, password, **opts)
          password
        end
      end
    end

    def self.Plaintext(hashed_password)
      Plaintext.new(hashed_password)
    end

    register :plaintext, Plaintext
  end
end
