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

      private

        def __authenticate__
          global_id = session[session_name]
          self.user = GlobalID::Locator.locate(global_id)
        end

        def __login__
          if user
            session[session_name] = user.to_global_id.to_s
          end
        end

        def __logout__
          session.delete(session_name)
        end

    end
  end
end
