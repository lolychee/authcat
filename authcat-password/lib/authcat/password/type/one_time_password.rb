# frozen_string_literal: true

module Authcat
  module Password
    module Type
      class OneTimePassword < Password
        # @return [Symbol, String, self]
        self.default_algorithm = :totp
      end
    end
  end
end
