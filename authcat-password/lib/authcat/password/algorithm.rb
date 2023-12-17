# frozen_string_literal: true

module Authcat
  module Password
    module Algorithm
      include Authcat::Utils::Registryable

      register(:plaintext) { Plaintext }
      register(:bcrypt) { BCrypt }
      register(:totp) { TOTP }
    end
  end
end
