module Authcat
  module Strategies
    extend ActiveSupport::Autoload
    extend ActiveSupport::Concern

    autoload :Abstract
    autoload :Base
    autoload :Debug
    autoload :Session
    autoload :Cookies

    extend Support::Registrable
    has_registry

    extend SingleForwardable
    def_delegators :registry, :register, :lookup

    register :debug,    Strategies::Debug
    register :session,  Strategies::Session
    register :cookies,  Strategies::Cookies
  end
end
