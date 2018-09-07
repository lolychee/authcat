# frozen_string_literal: true

module Authcat
  module Strategies
    extend Supports::Registrable
  end
end

require "authcat/strategies/abstract"
require "authcat/strategies/session"
require "authcat/strategies/cookies"
