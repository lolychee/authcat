ENV["RAILS_ENV"] = "test"

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'authcat'

require File.expand_path("../dummy/config/environment", __FILE__)
ActiveRecord::Migrator.migrations_paths = [File.expand_path("../dummy/db/migrate", __FILE__)]

Dir[File.expand_path("../support/**/*.rb", __FILE__)].each { |f| require f }

RSpec.configure do |config|

  config.include TestRequestHelper

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end

end
