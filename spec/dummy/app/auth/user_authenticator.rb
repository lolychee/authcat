class UserAuthenticator < Authcat::Authenticator
  credential :globalid, default: true

  strategy :cookies, key: :remember_token, expires_in: ->(user) { user.remember_me ? 30.days : nil }
end
