# frozen_string_literal: true

ENV["RACK_ENV"] ||= "test"
require_relative "dummy/config/environment"

require "authcat/webauthn"
require "active_record"

# ActiveRecord::Base.configurations = YAML.load_file(File.expand_path("dummy/config/database.yml", __dir__),
#                                                    aliases: true)
# ActiveRecord::Base.establish_connection ENV["RACK_ENV"].to_sym

# ActiveRecord::Migrator.migrations_paths = [
#   File.expand_path("dummy/db/migrate", __dir__),
#   File.expand_path("../db/migrate", __dir__)
# ]
# ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
