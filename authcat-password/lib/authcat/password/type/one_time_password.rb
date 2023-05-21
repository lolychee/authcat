# frozen_string_literal: true

module Authcat
  module Password
    module Type
      class OneTimePassword < Digest
        # @return [Symbol, String, self]
        self.default_algorithm = :totp
      end
    end
  end
end
