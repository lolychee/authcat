# frozen_string_literal: true

require "authcat/support"

module Authcat
  module Password
    module Algorithm
      include Authcat::Support::Registryable

      register(:plaintext) { Plaintext }
      register(:bcrypt) { BCrypt }
      register(:totp) { TOTP }
    end
  end
end
