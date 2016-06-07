module Authcat
  class Authenticator

    include Core
    include Providers
    include Callbacks
  end
end
