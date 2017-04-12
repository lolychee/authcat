require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task default: :spec

rule /^dummy:?/ do |t|
  task_name = ARGV.shift.sub(/^dummy:?/, "")
  sh "rake -f spec/dummy/Rakefile #{task_name} #{ARGV.join(' ')}"
end
