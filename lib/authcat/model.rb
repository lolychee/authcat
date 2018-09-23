# frozen_string_literal: true

require "authcat/model/secure_password"
require "authcat/model/tokenable"
require "authcat/model/validators"

module Authcat
  module Model
    def self.included(base)
      base.include SecurePassword
      base.include Tokenable
      base.include Validators
    end
  end
end
