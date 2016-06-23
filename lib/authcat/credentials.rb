module Authcat
  module Credentials
    extend ActiveSupport::Autoload

    autoload :Base
    autoload :GlobalID, 'authcat/credentials/global_id'

    SHORT_NAME_MAP = {
      global_id: 'GlobalID'
    }.with_indifferent_access

    def self.const_get(name)
      if SHORT_NAME_MAP.key?(name)
        super(SHORT_NAME_MAP[name])
      else
        super
      end
    end

    class InvalidCredential < StandardError; end

  end
end
