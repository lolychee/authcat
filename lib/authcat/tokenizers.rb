# frozen_string_literal: true

require "authcat/tokenizers/abstract"
require "authcat/tokenizers/jwt"

module Authcat
  module Tokenizers
    extend Supports::Registrable

    register :jwt, JWT
  end
end
