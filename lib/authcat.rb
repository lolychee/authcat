require 'active_support'
require 'active_support/rails'

module Authcat
  extend ActiveSupport::Autoload

  eager_autoload do
    autoload :VERSION

    autoload :Railtie
  end

  autoload :Authenticator
  autoload :Core
  autoload :Callbacks

  autoload :Strategies
  autoload :Credentials

  autoload :Model
  autoload :Password

  autoload :Support
  autoload :Registry

  autoload :Authentication

  eager_load!
end
