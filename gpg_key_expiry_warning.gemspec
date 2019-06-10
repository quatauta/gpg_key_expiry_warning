# frozen_string_literal: true

require_relative "lib/gpg_key_expiry_warning/version"

Gem::Specification.new do |s|
  s.name        = "gpg_key_expiry_warning"
  s.version     = GPGKeyExpiryWarning::VERSION
  s.homepage    = "https://github.com/quatauta/gpg_key_expiry_warning"
  s.summary     = "List GnuPG keys which expire soon"
  s.description = ""
  s.license     = "MIT"

  if s.respond_to?(:metadata=)
    s.metadata = {
      "bug_tracker_uri" => "https://github.com/quatauta/gpg_key_expiry_warning/issues",
      "changelog_uri" => "https://github.com/quatauta/gpg_key_expiry_warning/blob/master/CHANGELOG.md",
      "homepage_uri" => "https://github.com/quatauta/gpg_key_expiry_warning",
      "source_code_uri" => "https://github.com/quatauta/gpg_key_expiry_warning",
    }
  end

  s.author = "Daniel Schömer"
  s.email  = "daniel.schoemer@gmx.net"

  s.required_ruby_version = "~> 2.3"
  s.add_runtime_dependency "cri", ">= 2.15"
  s.add_runtime_dependency "gpgme", ">= 2.0"
  s.add_development_dependency "rake", ">= 12"
  s.add_development_dependency "standard", ">= 0.0.40"

  s.rdoc_options     = ["--main", "README.md"]
  s.extra_rdoc_files = ["LICENSE", "README.md", "NEWS.md"]

  s.files = ["gpg_key_expiry_warning.gemspec"]
  s.files += Dir.glob("{bin,lib,test}/**/*", File::FNM_DOTMATCH).reject { |f| File.directory?(f) }
  s.files += Dir["[A-Z]*"]

  s.bindir        = "bin"
  s.executables   = %w[gpg_key_expiry_warning]
  s.require_paths = ["lib"]
end
