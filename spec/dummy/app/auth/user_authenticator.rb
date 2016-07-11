class UserAuthenticator < Authcat::Authenticator

  use :cookies, key: :remember_token, expires_in: ->(user) { user.remember_me ? 2.minutes : nil }
end
