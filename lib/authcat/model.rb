# frozen_string_literal: true

module Authcat
  module Model
    def self.included(base)
      base.include SecurePassword
      base.include Tokenable
    end
  end
end

require "authcat/model/secure_password"
require "authcat/model/tokenable"
