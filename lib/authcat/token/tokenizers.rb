# frozen_string_literal: true

require "authcat/token/tokenizers/abstract"
require "authcat/token/tokenizers/jwt"

module Authcat
  module Token
    module Tokenizers
      extend Supports::Registrable

      register :jwt, JWT
    end
  end
end
