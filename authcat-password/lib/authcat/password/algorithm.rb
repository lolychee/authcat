# frozen_string_literal: true

require "authcat/support"

module Authcat
  module Password
    module Algorithm
      include Authcat::Support::ActsAsRegistry

      register(:plaintext) { Plaintext }
      register(:bcrypt) { BCrypt }
    end
  end
end
