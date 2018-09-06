# frozen_string_literal: true

module Authcat
  module Strategies
    extend Support::Registrable
  end
end

require "authcat/strategies/abstract"
require "authcat/strategies/session"
require "authcat/strategies/cookies"
