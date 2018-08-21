require "active_support"
require "active_support/rails"

module Authcat
  extend ActiveSupport::Autoload

  autoload :VERSION

  autoload :Authenticator
  autoload :Core
  autoload :Callbacks
  
  autoload :Model
  
  autoload :Strategy
  autoload :Support

  eager_autoload do
    autoload :Password
    autoload :Locator
    autoload :Tokenizer
    autoload :Railtie
  end

  eager_load!
end
