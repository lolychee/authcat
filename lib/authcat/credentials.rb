module Authcat
  module Credentials
    extend ActiveSupport::Autoload
    extend ActiveSupport::Concern

    autoload :Abstract
    autoload :GlobalID, 'authcat/credentials/globalid'

    extend Support::Registrable
    has_registry reader: ->(value) { value.is_a?(Class) ? value : Authcat::Credentials.const_get(value) }

    extend SingleForwardable
    def_delegators :registry, :register, :lookup

    register :globalid, :GlobalID

    included do
      has_registry :credentials
    end

  end
end
