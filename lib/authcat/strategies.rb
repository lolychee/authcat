# frozen_string_literal: true

require "authcat/strategies/abstract"
require "authcat/strategies/session"
require "authcat/strategies/cookies"

module Authcat
  module Strategies
    extend Supports::Registrable

    register :session, Session
    register :cookies, Cookies
  end
end
