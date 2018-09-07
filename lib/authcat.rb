# frozen_string_literal: true

require "authcat/version"
require "authcat/supports"
require "authcat/extensions"
require "authcat/authenticator"
require "authcat/middleware"
require "authcat/passwords"
require "authcat/strategies"
require "authcat/tokenizers"
require "authcat/model"
require "authcat/railtie"

module Authcat
  class << self
    attr_accessor :secret_key
  end
end
