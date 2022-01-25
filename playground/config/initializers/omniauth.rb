# frozen_string_literal: true

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer unless Rails.env.production?
  provider :twitter, ENV["OMNIAUTH_TWITTER_KEY"], ENV["OMNIAUTH_TWITTER_SECRET"] if ENV.key?("OMNIAUTH_TWITTER_KEY")
  provider :github, ENV["OMNIAUTH_GITHUB_KEY"], ENV["OMNIAUTH_GITHUB_SECRET"] if ENV.key?("OMNIAUTH_GITHUB_KEY")
end
