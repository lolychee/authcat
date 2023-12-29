# frozen_string_literal: true

require "active_record"
require "erb"

ActiveRecord::Tasks::DatabaseTasks.tap do |dt|
  dt.env = ENV["RACK_ENV"].to_sym
  dt.root = File.expand_path("spec/support")
  dt.db_dir = File.expand_path("db", dt.root)
  dt.migrations_paths = [File.expand_path("migrate", dt.db_dir)]
  dt.database_configuration = YAML.load(
    ERB.new(File.read(File.expand_path("database.yml", dt.root))).result,
    aliases: true
  )
end
# other settings...

task :environment do
  ActiveRecord::Base.configurations = ActiveRecord::Tasks::DatabaseTasks.database_configuration
  ActiveRecord::Base.establish_connection ActiveRecord::Tasks::DatabaseTasks.env
end

load "active_record/railties/databases.rake"
