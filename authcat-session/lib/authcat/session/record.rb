# frozen_string_literal: true

module Authcat
  module Session
    module Record
      def self.included(base)
        base.extend ClassMethods

        require "authcat/identity"
        base.include Authcat::Identity::Validators
        require "authcat/password"
        base.include Authcat::Password::Validators
      end

      module ClassMethods
      end
    end
  end
end
