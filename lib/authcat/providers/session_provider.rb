require 'global_id'

module Authcat
  module Providers
    class SessionProvider < Provider

      option :session_name, reader: true

      def authenticate(authenticator)
        authenticator.user = from_token(get_token(authenticator.request))
      end

      def sign_in(authenticator)
        set_token(authenticator.request, to_token(authenticator.user))
      end

      def sign_out(authenticator)
        set_token(authenticator.request, nil)
      end

      private

        def get_token(request)
          request.session[session_name]
        end

        def set_token(request, token)
          if token.nil?
            request.session.delete(session_name)
          else
            request.session[session_name] = token
          end
        end

        def from_token(token)
          token.nil? ? nil : GlobalID::Locator.locate(token)
        end

        def to_token(user)
          user.to_global_id.to_s
        end

        Providers.register(:session, self)
    end
  end
end
