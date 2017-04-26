class UserAuthenticator < Authcat::Authenticator
  credential :globalid, default: true

  strategy :cookies, key: :remember_token, expires_in: ->(_, params) { params[:remember_me] ? 30.days : nil }
end
