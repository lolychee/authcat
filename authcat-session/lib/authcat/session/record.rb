# frozen_string_literal: true

require "authcat/authenticator"
require "authcat/identifier"

module Authcat
  module Session
    module Record
      def self.included(base)
        base.include Authcat::Identifier,
                     Authcat::Authenticator::Validators
      end
    end
  end
end
