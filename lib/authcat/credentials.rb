module Authcat
  module Credentials
    extend ActiveSupport::Autoload

    autoload :Abstract
    autoload :GlobalID, "authcat/credentials/globalid"

    extend Support::Registrable
    has_registry

    extend SingleForwardable
    def_delegators :registry, :register, :lookup

    register :globalid, Credentials::GlobalID
  end
end
