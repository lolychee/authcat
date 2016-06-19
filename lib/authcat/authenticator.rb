module Authcat
  class Authenticator

    include Core
    include Strategies
    include Callbacks
  end
end
