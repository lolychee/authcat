# frozen_string_literal: true

module Authcat
  module Password
    module Algorithms
      class Plaintext < Abstract
        class << self
          def valid?(password)
            password.is_a?(String)
          end

          def hash(password, **opts)
            password
          end
        end
      end
    end
  end
end
