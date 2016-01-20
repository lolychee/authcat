module Authcat
  module Strategies
    module Session
      extend ActiveSupport::Concern

      included do
        define_option_method :session_name
      end

      module ClassMethods

      end

      def session
        request.session
      end

      def _authenticate
        global_id = session[session_name]
        self.user = GlobalID::Locator.locate(global_id)
      end

      def _login
        if user
          session[session_name] = user.to_global_id.to_s
        end
      end

      def _logout
        session.delete(session_name)
      end

    end
  end
end
