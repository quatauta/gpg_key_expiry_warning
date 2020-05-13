require "bundler/audit/task"
require "bundler/gem_tasks"
require "bundler/plumber/task"
require "rspec/core/rake_task"
require "rubocop/rake_task"
require "rubycritic/rake_task"
require "standard/rake"

Bundler::Audit::Task.new
Bundler::Plumber::Task.new
RSpec::Core::RakeTask.new(:spec)
RuboCop::RakeTask.new

RubyCritic::RakeTask.new do |task|
  task.paths = FileList["{bin,exe,lib,spec}/**/*.rb"]
  task.options = "--no-browser"
end

RubyCritic::RakeTask.new do |task|
  task.name = "rubycritic:ci"
  task.paths = FileList["{bin,exe,lib,spec}/**/*.rb"]
  task.options = "--no-browser --mode-ci --format json"
end

desc "Run fasterer"
task :fasterer do
  sh "fasterer"
end

desc "Run skunk"
task :skunk do
  sh "skunk"
end

desc "Run tasks for CI (bundle:audit bundle:leak rubocop standard fasterer rubycritic:ci skunk spec)"
task ci: ["bundle:audit", "bundle:leak", :rubocop, :standard, :fasterer, "rubycritic:ci", :skunk, :spec]

desc "Run standard:fix and CI tasks"
task default: ["standard:fix", :ci]
