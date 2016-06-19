module Authcat
  module Credentials
    extend ActiveSupport::Autoload

    extend Support::Registrable

    eager_autoload do
      autoload :Base
      autoload :GlobalID, 'authcat/credentials/global_id'
    end

    class InvalidCredential < StandardError; end

    # eager_load!
  end
end
