# frozen_string_literal: true

module Authcat
  module Password
    module Algorithms
      class Plaintext < Abstract
        class << self
          def valid?(password, **opts)
            password.is_a?(String)
          end

          def __hash__(password, **opts)
            password
          end
        end
      end
    end
  end
end
