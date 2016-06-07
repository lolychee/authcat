require 'active_support'
require 'active_support/rails'

module Authcat
  extend ActiveSupport::Autoload

  eager_autoload do
    autoload :VERSION

    autoload :Authenticator
    autoload :Core
    autoload :Callbacks
    autoload :Model
    autoload :Password

    autoload :Provider
    autoload :Providers

    autoload :Options
    autoload :Registry
  end

  eager_load!
end
