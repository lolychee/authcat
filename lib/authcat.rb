# frozen_string_literal: true

require "authcat/version"
require "authcat/supports"
require "authcat/authenticator"
require "authcat/token"
require "authcat/password"
require "authcat/identity"
require "authcat/railtie"

module Authcat
  class << self
    attr_accessor :secret_key
  end
end
