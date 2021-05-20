# frozen_string_literal: true

source "https://rubygems.org"

# Specify your gem's dependencies in authcat.gemspec
gemspec

gem "rake", "~> 13.0"

group :test do
  gem "rspec", "~> 3.0"
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
