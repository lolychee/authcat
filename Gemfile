# frozen_string_literal: true

source ENV["GEM_SOURCE"] || "https://rubygems.org"

# Specify your gem"s dependencies in authcat.gemspec
gemspec

# # Bundle edge Rails instead: gem "rails", github: "rails/rails"
# gem "rails", "~> 5.0"
#
# # Use sqlite3 as the database for Active Record
# gem "sqlite3"
# # Use Puma as the app server
# gem "puma"
#
# gem "bcrypt", require: false
#
# gem "pure-css-rails"

gem "pry"

group :test do
  gem "database_cleaner", "~> 1.5"
  gem "rspec", "~> 3.5"

  gem "simplecov", require: false
end

group :development do
  gem "rubocop"
  gem "rubocop-rails_config"
  gem "rubocop-rspec"
end

dummy_gemfile = File.expand_path("spec/dummy/Gemfile", __dir__)
eval_gemfile dummy_gemfile, File.read(dummy_gemfile).gsub(/(source|gem \"authcat\").*\n/, "")
