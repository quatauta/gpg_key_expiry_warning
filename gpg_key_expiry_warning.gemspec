# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "gpg_key_expiry_warning/version"

Gem::Specification.new do |spec|
  spec.name = "gpg_key_expiry_warning"
  spec.version = GpgKeyExpiryWarning::VERSION
  spec.authors = ["Daniel Schömer"]
  spec.email = ["daniel.schoemer@gmx.net"]
  spec.summary = "List GnuPG keys which expire soon"
  spec.description = ""
  spec.homepage = "https://github.com/quatauta/gpg_key_expiry_warning"
  spec.license = "MIT"

  spec.metadata["source_code_uri"] = "https://github.com/quatauta/gpg_key_expiry_warning"
  spec.metadata["bug_tracker_uri"] = "https://github.com/quatauta/gpg_key_expiry_warning/issues"

  spec.files = Dir.glob("{bin,exe,lib}/**/*")
  spec.test_files = Dir.glob("{test,spec,features}/**/*.*")

  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.extra_rdoc_files = ["LICENSE.txt", "README.md", "CODE_OF_CONDUCT.md"]

  spec.required_ruby_version = ">= 2.5"

  spec.add_runtime_dependency "cri", "~> 2.15.0"
  spec.add_runtime_dependency "zeitwerk", "~> 2.4.0"

  spec.add_development_dependency "amazing_print", "~> 1.2.0"
  spec.add_development_dependency "bundler", "~> 2.1"
  spec.add_development_dependency "bundler-audit", "~> 0.7.0"
  spec.add_development_dependency "bundler-leak", "~> 0.2.0"
  spec.add_development_dependency "fasterer", "~> 0.9.0"
  spec.add_development_dependency "fuubar", "~> 2.5.0"
  spec.add_development_dependency "libyear-bundler", "~> 0.5.0"
  spec.add_development_dependency "pry", "~> 0.14.0"
  spec.add_development_dependency "rake", "~> 13.0.0"
  spec.add_development_dependency "rspec", "~> 3.10.0"
  spec.add_development_dependency "rspec_junit_formatter", "~> 0.4.0"
  spec.add_development_dependency "rubocop", "~> 1.11.0"
  spec.add_development_dependency "rubocop-performance", "~> 1.10.1"
  spec.add_development_dependency "rubocop-rake", "~> 0.5.0"
  spec.add_development_dependency "rubocop-rspec", "~> 2.2.0"
  spec.add_development_dependency "rubycritic", "~> 4.6.0"
  spec.add_development_dependency "simplecov", "~> 0.20.0"
  spec.add_development_dependency "standard", "~> 1.0.4"
end
