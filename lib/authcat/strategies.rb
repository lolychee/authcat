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
    has_registry reader: ->(value) { value.is_a?(Class) ? value : Authcat::Strategies.const_get(value) }

    extend SingleForwardable
    def_delegators :registry, :register, :lookup

    register :debug,    :Debug
    register :session,  :Session
    register :cookies,  :Cookies

  end
end
