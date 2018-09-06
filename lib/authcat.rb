require "active_support"
require "active_support/rails"

module Authcat
  extend ActiveSupport::Autoload

  eager_autoload do
    autoload :Password
    autoload :Railtie
    autoload :Support
    autoload :Tokenizer
  end

  eager_load!

  autoload :VERSION

  autoload :Authenticator
  autoload :Callbacks
  autoload :Middleware
  autoload :Model
  autoload :Strategy

  cattr_accessor :secret_key
end
