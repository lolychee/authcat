# frozen_string_literal: true

require "authcat/version"
require "authcat/supports"
require "authcat/authenticator"
require "authcat/token"
require "authcat/password"
require "authcat/two_factor"
require "authcat/model"
require "authcat/railtie"

module Authcat
  class << self
    attr_accessor :secret_key
  end
end
