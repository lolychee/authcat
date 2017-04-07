module Authcat
  module Credentials
    extend ActiveSupport::Autoload

    extend Support::Registrable

    autoload :Abstract
    autoload :GlobalID, 'authcat/credentials/globalid'

    register :globalid, :GlobalID

    def self.lookup(name)
      super do |value|
        value.is_a?(Class) ? value : const_get(value)
      end
    end

    def self.create(type, identity, **options)
      klass = lookup(type)
      klass.create(identity, **options)
    end

    def self.parse(type, credential, **options)
      klass = lookup(type)
      klass.new(credential, **options)
    end

    class Error < StandardError; end

    class InvalidCredentialError < Error; end
    class InvalidIdentityError   < Error; end

  end
end
