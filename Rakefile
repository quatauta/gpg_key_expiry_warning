require "bundler/audit/task"
require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "rubycritic/rake_task"
require "standard/rake"

Bundler::Audit::Task.new

RSpec::Core::RakeTask.new(:spec)

RubyCritic::RakeTask.new do |task|
  task.options = "--no-browser"
end

desc "Run fasterer"
task :fasterer do |task|
  sh "fasterer"
end

multitask default: ["bundle:audit", "fasterer", "rubycritic", "spec", "standard:fix"]
