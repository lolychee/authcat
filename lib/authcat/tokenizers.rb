module Authcat
  module Tokenizer
    extend Support::Registrable
  end
end

require "authcat/tokenizer/abstract"
require "authcat/tokenizer/jwt"
