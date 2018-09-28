# frozen_string_literal: true

module Authcat
  module Model
    def self.included(base)
      base.include Token::Tokenable
      base.include Password::SecurePassword
      base.include Password::Validators
    end
  end
end
