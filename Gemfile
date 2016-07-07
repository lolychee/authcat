source ENV['GEM_SOURCE'] || 'https://rubygems.org'

# Specify your gem's dependencies in authcat.gemspec
gemspec

# # Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
# gem 'rails', '~> 5.0'
#
# # Use sqlite3 as the database for Active Record
# gem 'sqlite3'
# # Use Puma as the app server
# gem 'puma'
#
# gem 'bcrypt', require: false
#
# gem 'pure-css-rails'

group :test do
  gem 'rspec', '~> 3.5'
  gem 'database_cleaner', '~> 1.5'
end

ENV['GEM_DEV'] = 'true'
eval_gemfile File.expand_path('spec/dummy/Gemfile', __dir__)
