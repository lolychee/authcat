module Authcat
  module Strategy
    class Session < Abstract
      def call(env)
        request = ActionDispatch::Request.new(env)
        session = request.session

       @app.call(env)
      end

      def key
        options[:key] || :access_token
      end

    end
  end
end
