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

  spec.files = Dir.glob("{bin,lib}/**/*.*")
  spec.test_files = Dir.glob("{test,spec,features}/**/*.*")

  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.extra_rdoc_files = ["LICENSE.txt", "README.md", "CODE_OF_CONDUCT.md"]

  spec.required_ruby_version = ">= 2.5"

  spec.add_runtime_dependency "cri", ">= 2.15"
  spec.add_runtime_dependency "zeitwerk", ">= 2.2"
end
