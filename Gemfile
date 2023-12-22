# frozen_string_literal: true

source "https://rubygems.org"

# ruby file: File.join(File.dirname(__FILE__), ".ruby-version")

# Specify your gem's dependencies in authcat.gemspec
gemspec

gem "rake", "~> 13.0"

group :test do
  gem "faker"
  gem "rspec", "~> 3.0"

  gem "simplecov", require: false
  gem "simplecov-lcov", require: false
end

group :lint do
  gem "rubocop",                require: false
  gem "rubocop-packaging",      require: false
  gem "rubocop-performance",    require: false
  gem "rubocop-rake",           require: false
  gem "rubocop-rspec",          require: false
  gem "rubocop-rubycw",         require: false
  gem "rubocop-thread_safety",  require: false
end

group :doc do
  gem "rdoc"
end

gem "rails", "~> 6.1"

gem "database_cleaner", "~> 2.0"

gem "pg", require: false
gem "sqlite3"

gem "dry-container"

gem "bcrypt"
gem "omniauth",     require: false
gem "phonelib",     require: false
gem "rotp",         require: false
gem "valid_email2", require: false
gem "webauthn",     require: false

gem "state_machines-activerecord", require: false

group :development do
  gem "debug"
  gem "listen", "~> 3.3"
  gem "steep"
end

path "." do
  gem "authcat-account",        require: false
  gem "authcat-authenticator",  require: false
  gem "authcat-credential",     require: false
  gem "authcat-identifier",     require: false
  gem "authcat-idp",            require: false
  gem "authcat-passkey",        require: false
  gem "authcat-password",       require: false
  gem "authcat-session",        require: false
  gem "authcat-support",        require: false
end
