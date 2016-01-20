require "active_support"
require "active_support/rails"

module Authcat
  extend ActiveSupport::Autoload

  autoload :VERSION

  autoload :Authenticator
  autoload :Callbacks
  autoload :Core
  autoload :Strategies
  autoload :Validations
end
