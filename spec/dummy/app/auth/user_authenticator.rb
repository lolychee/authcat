class UserAuthenticator < Authcat::Authenticator

  use :session, key: :auth_token
end
