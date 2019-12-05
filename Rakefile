# frozen_string_literal: true

require "bundler/audit/task"
require "bundler/gem_tasks"
require "bundler/plumber/task"
require "rspec/core/rake_task"
require "rubycritic/rake_task"
require "standard/rake"

Bundler::Audit::Task.new
Bundler::Plumber::Task.new

RSpec::Core::RakeTask.new(:spec)

RubyCritic::RakeTask.new do |task|
  task.options = "--no-browser"
  task.paths = %w[bin exe lib spec]
end

desc "Run fasterer"
task :fasterer do |task|
  sh "fasterer"
end

desc "Run bundle:audit, bundle, leak, standard, fasterer, spec tasks for CI"
task ci: ["bundle:audit", "bundle:leak", :standard, :fasterer, :spec]

desc "Run standard:fix, rubycritic and CI tasks"
task default: ["standard:fix", :rubycritic, :ci]
