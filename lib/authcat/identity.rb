# frozen_string_literal: true

require "authcat/identity/password_auth"
require "authcat/identity/two_factor_auth"
require "authcat/identity/identifier"
require "authcat/identity/sign_in"

module Authcat
  module Identity
    extend Supports::Registrable

    register :password_auth,   PasswordAuth
    register :two_factor_auth, TwoFactorAuth
    register :identifier,      Identifier
    register :sign_in,         SignIn

    def self.included(base)
      base.extend ClassMethods

      base.include Token::Tokenable
      base.tokenable
    end

    module ClassMethods
      def authcat(name)
        mod = ::Authcat::Identity.lookup(name)
        raise "Invalid module: #{name.inspect}" unless mod.respond_to?(:setup)
        mod.setup(self)
      end
    end
  end
end
