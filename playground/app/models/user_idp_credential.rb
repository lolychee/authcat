# frozen_string_literal: true

class UserIdentityProviderCredential < ApplicationRecord
  include Authcat::IdentityProvider::Record

  belongs_to :user

  omniauth_provider :developer if Rails.env.development?

  if true # ENV.key?("OMNIAUTH_TWITTER_KEY")
    omniauth_provider :twitter,
                      ENV.fetch("OMNIAUTH_TWITTER_KEY", nil),
                      ENV.fetch("OMNIAUTH_TWITTER_SECRET", nil)
  end

  if true # ENV.key?("OMNIAUTH_GITHUB_KEY")
    omniauth_provider :github,
                      ENV.fetch("OMNIAUTH_GITHUB_KEY", nil),
                      ENV.fetch("OMNIAUTH_GITHUB_SECRET", nil)
  end

  if true # ENV.key?("OMNIAUTH_GOOGLE_KEY")
    omniauth_provider :google_oauth2,
                      ENV.fetch("OMNIAUTH_GOOGLE_KEY", nil),
                      ENV.fetch("OMNIAUTH_GOOGLE_SECRET", nil)
  end
end
