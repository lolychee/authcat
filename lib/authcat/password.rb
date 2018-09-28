# frozen_string_literal: true

require "authcat/password/algorithms"
require "authcat/password/extensions"
require "authcat/password/validators"
require "authcat/password/utils"
require "authcat/password/secure_password"

module Authcat
  module Password
    class << self
      attr_accessor :default_algorithm
    end

    self.default_algorithm = :bcrypt
  end
end
