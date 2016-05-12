require 'authcat/core'
require 'authcat/callbacks'

module Authcat
  class Authenticator

    include Core

    include Callbacks
  end
end
