# frozen_string_literal: true

require "authcat/password/algorithms/abstract"
require "authcat/password/algorithms/plaintext"
require "authcat/password/algorithms/bcrypt"

module Authcat
  module Password
    module Algorithms
      extend Supports::Registrable

      register :plaintext, Plaintext
      register :bcrypt,    BCrypt
    end
  end
end
