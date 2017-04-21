require "active_support"
require "active_support/rails"

module Authcat
  extend ActiveSupport::Autoload

  autoload :VERSION

  autoload :Authenticator
  autoload :Core
  autoload :Callbacks

  autoload :Strategies
  autoload :Credentials

  autoload :Model
  autoload :Validators
  autoload :Password

  autoload :Support

  autoload :Authentication

  eager_autoload do
    autoload :Errors
    autoload :Railtie
  end

  eager_load!
end
