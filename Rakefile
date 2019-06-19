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

namespace :spec do
  desc "Run RSpec code examples and report to tmp/rspec.xml"
  RSpec::Core::RakeTask.new(:junit) do |task|
    task.rspec_opts = "--format RspecJunitFormatter --out tmp/rspec.xml"
  end
end

task default: ["bundle:audit", "fasterer", "rubycritic", "spec", "standard:fix"]
