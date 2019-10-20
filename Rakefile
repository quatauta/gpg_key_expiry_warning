# frozen_string_literal: true

require "bundler/audit/task"
require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "rubycritic/rake_task"
require "standard/rake"
require "bundler/plumber/task"

Bundler::Audit::Task.new
Bundler::Plumber::Task.new

RSpec::Core::RakeTask.new(:spec)

RubyCritic::RakeTask.new do |task|
  task.options = "--no-browser"
end

desc "Run fasterer"
task :fasterer do |task|
  sh "fasterer"
end

task default: ["bundle:audit", "bundle:leak", "standard:fix", :fasterer, :rubycritic, :spec]
