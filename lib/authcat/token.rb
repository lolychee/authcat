# frozen_string_literal: true

require "authcat/token/tokenizers"
require "authcat/token/tokenable"

module Authcat
  module Token
    class << self
      attr_accessor :default_tokenizer
    end

    self.default_tokenizer = :jwt
  end
end
