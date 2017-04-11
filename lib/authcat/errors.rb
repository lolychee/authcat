module Authcat
  module Errors
    extend ActiveSupport::Autoload

    class Error < StandardError; end

    class InvalidCredential < Error; end
    class InvalidIdentity   < Error; end
    class StrategyReadonly  < Error; end
    class IdentityNotFound  < Error; end
  end
end
