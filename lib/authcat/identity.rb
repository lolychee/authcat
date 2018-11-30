# frozen_string_literal: true
require "authcat/identity/password_auth"
require "authcat/identity/two_factor_auth"

module Authcat
  module Identity
    extend Supports::Registrable

    register :password_auth, PasswordAuth
    register :two_factor_auth, TwoFactorAuth

    def self.included(base)
      base.extend ClassMethods

      base.include Token::Tokenable
      base.tokenable
    end

    module ClassMethods
      def authcat(mod_name)
        mod = Identity.lookup(mod_name)
        mod.setup(self) if mod.respond_to?(:setup)
      end
    end
  end
end
