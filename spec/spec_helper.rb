# frozen_string_literal: true

ENV["LANG"] = nil

require "simplecov"
SimpleCov.start do
  command_name "RSpec"
end

require "bundler/setup"
require "gpg_key_expiry_warning"

RSpec.configure do |config|
  config.disable_monkey_patching!
  config.example_status_persistence_file_path = "tmp/rspec-status.txt"
  config.order = :random
  Kernel.srand config.seed

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
