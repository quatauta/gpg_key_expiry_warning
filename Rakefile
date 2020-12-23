# frozen_string_literal: true

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

desc "Run libyear-bundler to measure dependency freshness"
task :libyear do
  sh "bundle exec libyear-bundler --all"
end

desc "Run RuboCop and do not fail"
task "rubocop:pass" do
  Rake::Task["rubocop"].invoke
rescue SystemExit
  true
end

desc "Run tests"
task test: %i[spec]

desc "Run tasks for CI (bundle:audit bundle:leak rubocop:pass standard fasterer rubycritic skunk test)"
task ci: %i[bundle:audit bundle:leak rubocop:pass standard fasterer rubycritic skunk test]

desc "Run standard:fix and CI tasks"
task default: %i[standard:fix ci]
