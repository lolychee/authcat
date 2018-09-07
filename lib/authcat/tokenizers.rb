# frozen_string_literal: true

module Authcat
  module Tokenizers
    extend Supports::Registrable
  end
end

require "authcat/tokenizers/abstract"
require "authcat/tokenizers/jwt"
