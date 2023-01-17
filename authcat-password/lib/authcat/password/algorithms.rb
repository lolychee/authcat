# frozen_string_literal: true

require "dry/container"
require "forwardable"

module Authcat
  module Password
    module Algorithms
      class << self
        extend Forwardable

        def_delegators :registry, :register, :resolve

        # @return [Dry::Container]
        def registry
          @registry ||= Dry::Container.new
        end
      end

      register(:plaintext) { Plaintext }
      register(:bcrypt) { BCrypt }
      register(:totp) { TOTP }
    end
  end
end
