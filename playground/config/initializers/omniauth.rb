# frozen_string_literal: true

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer if Rails.env.development?
  if true #ENV.key?("OMNIAUTH_TWITTER_KEY")
    provider :twitter, ENV["OMNIAUTH_TWITTER_KEY"],
             ENV.fetch("OMNIAUTH_TWITTER_SECRET", nil)
  end
  if true #ENV.key?("OMNIAUTH_GITHUB_KEY")
    provider :github, ENV["OMNIAUTH_GITHUB_KEY"],
             ENV.fetch("OMNIAUTH_GITHUB_SECRET", nil)
  end
  if true #ENV.key?("OMNIAUTH_GOOGLE_KEY")
    provider :google_oauth2, ENV["OMNIAUTH_GOOGLE_KEY"],
             ENV.fetch("OMNIAUTH_GOOGLE_SECRET", nil)
  end
end
