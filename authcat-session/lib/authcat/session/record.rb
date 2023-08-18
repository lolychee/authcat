# frozen_string_literal: true

require "authcat/authenticator"

module Authcat
  module Session
    module Record
      def self.included(base)
        base.include Authcat::Authenticator::Validators
      end
    end
  end
end
