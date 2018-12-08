# frozen_string_literal: true

require "authcat/identity/identifier"
require "authcat/identity/password_auth"
require "authcat/identity/two_factor_auth"

module Authcat
  module Identity
    extend Supports::Registrable

    register :identifier,      Identifier
    register :password_auth,   PasswordAuth
    register :two_factor_auth, TwoFactorAuth

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
