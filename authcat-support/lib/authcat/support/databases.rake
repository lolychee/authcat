# frozen_string_literal: true

require "active_record"
require "erb"

# other settings...
desc "Load the environment"
task :environment do
  ActiveRecord::Tasks::DatabaseTasks.tap do |dt|
    dt.env = ENV.fetch("RACK_ENV", "development")
    dt.root = File.expand_path("spec/support")
    dt.db_dir = File.expand_path("db", dt.root)
    dt.migrations_paths = [File.expand_path("migrate", dt.db_dir)]
    dt.database_configuration = YAML.load(
      ERB.new(File.read(File.expand_path("database.yml", dt.root))).result,
      aliases: true
    )
    ActiveRecord::Base.configurations = dt.database_configuration
    ActiveRecord::Base.establish_connection dt.env.to_sym
  end
end
load "active_record/railties/databases.rake"
