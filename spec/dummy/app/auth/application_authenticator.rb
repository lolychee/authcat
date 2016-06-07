class ApplicationAuthenticator < Authcat::Authenticator

  use :session, session_name: :auth_token
end
