# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "gpg_key_expiry_warning/version"

Gem::Specification.new do |spec|
  spec.name        = "gpg_key_expiry_warning"
  spec.version     = GPGKeyExpiryWarning::VERSION
  spec.authors     = ["Daniel Schömer"]
  spec.email       = ["daniel.schoemer@gmx.net"]
  spec.summary     = "List GnuPG keys which expire soon"
  spec.description = ""
  spec.homepage    = "https://github.com/quatauta/gpg_key_expiry_warning"
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
    spec.metadata["homepage_uri"] = spec.homepage
    spec.metadata["source_code_uri"] = "https://github.com/quatauta/gpg_key_expiry_warning"
    spec.metadata["changelog_uri"] = "https://github.com/quatauta/gpg_key_expiry_warning/blob/master/CHANGELOG.md"
    spec.metadata["bug_tracker_uri"] = "https://github.com/quatauta/gpg_key_expiry_warning/issues"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end

  spec.bindir           = "exe"
  spec.executables      = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths    = ["lib"]
  spec.extra_rdoc_files = ["LICENSE.txt", "README.md", "CODE_OF_CONDUCT.md"]

  spec.required_ruby_version = ">= 2.5"

  spec.add_runtime_dependency "cri", "~> 2.15"
end
