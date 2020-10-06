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

desc "Run fasterer"
task :fasterer do
  sh "bundle exec fasterer"
end

desc "Run skunk"
task :skunk do
  sh "bundle exec skunk"
end

desc "Run tasks for CI (bundle:audit bundle:leak rubocop standard fasterer rubycritic skunk spec)"
task ci: ["bundle:audit", "bundle:leak", :rubocop, :standard, :fasterer, "rubycritic", :skunk, :spec]

desc "Run standard:fix and CI tasks"
task default: ["standard:fix", :ci]
