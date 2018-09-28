# frozen_string_literal: true

require "authcat/authenticator/strategies/abstract"
require "authcat/authenticator/strategies/session"
require "authcat/authenticator/strategies/cookies"

module Authcat
  class Authenticator
    module Strategies
      extend Supports::Registrable

      register :session, Session
      register :cookies, Cookies
    end
  end
end
