require "active_support"
require "active_support/rails"

module Authcat
  extend ActiveSupport::Autoload

  autoload :Version

  autoload :Authenticator
  autoload :Callbacks
  autoload :Core
  autoload :Strategies
  autoload :Validations
end
