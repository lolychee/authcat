module Authcat
  class Authenticator
    # include Core
    # include Callbacks

    def initialize(app)
      @app = app
    end

    def call(env)
      status, headers, body = @app.call(env)

      [status, headers, body]
    end

  end
end
