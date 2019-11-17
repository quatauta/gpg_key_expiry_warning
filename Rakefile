# frozen_string_literal: true

require "bundler/audit/task"
require "rubycritic/rake_task"
require "standard/rake"
require "bundler/plumber/task"

Bundler::Audit::Task.new
Bundler::Plumber::Task.new

RubyCritic::RakeTask.new do |task|
  task.options = "--no-browser"
end

desc "Run fasterer"
task :fasterer do |task|
  sh "fasterer"
end

desc "Please use 'toys' to run scripts, and 'toys ci' for all default/test scripts."
task :default do
  puts "Please use 'toys' to run scripts, and 'toys ci' for all default/test scripts."
end
