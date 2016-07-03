module Authcat
  module Credentials
    extend ActiveSupport::Autoload

    extend Support::Registrable

    autoload :Base
    autoload :GlobalID, 'authcat/credentials/globalid'

    register :globalid, :GlobalID

    def self.lookup(name)
      super do |value|
        value.is_a?(Class) ? value : const_get(value)
      end
    end

    class InvalidCredential < StandardError; end

  end
end
