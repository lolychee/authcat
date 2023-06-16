# frozen_string_literal: true

module Authcat
  module Password
    module Type
      class DigestPassword < Password
        self.default_algorithm = :bcrypt
      end
    end
  end
end
