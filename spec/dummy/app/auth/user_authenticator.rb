class UserAuthenticator < Authcat::Authenticator

  scope :web do
    use :cookies, key: :auth_token, expires_in: ->(user) { user.remember_me ? 2.minutes : :session }
  end
end
