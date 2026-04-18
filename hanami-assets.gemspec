# frozen_string_literal: true

# This file is synced from hanakai-rb/repo-sync. To update it, edit repo-sync.yml.

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "hanami/assets/version"

Gem::Specification.new do |spec|
  spec.name          = "hanami-assets"
  spec.authors       = ["Hanakai team"]
  spec.email         = ["info@hanakai.org"]
  spec.license       = "MIT"
  spec.version       = Hanami::Assets::VERSION.dup

  spec.summary       = "Assets management for Ruby web applications"
  spec.description   = spec.summary
  spec.homepage      = "https://hanamirb.org"
  spec.files         = Dir["CHANGELOG.md", "LICENSE", "README.md", "hanami-assets.gemspec", "lib/**/*"]
  spec.bindir        = "exe"
  spec.executables   = Dir["exe/*"].map { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.extra_rdoc_files = ["README.md", "CHANGELOG.md", "LICENSE"]

  spec.metadata["changelog_uri"]     = "https://github.com/hanami/hanami-assets/blob/main/CHANGELOG.md"
  spec.metadata["source_code_uri"]   = "https://github.com/hanami/hanami-assets"
  spec.metadata["bug_tracker_uri"]   = "https://github.com/hanami/hanami-assets/issues"
  spec.metadata["funding_uri"]       = "https://github.com/sponsors/hanami"

  spec.required_ruby_version = ">= 3.2"

  spec.add_runtime_dependency "zeitwerk", "~> 2.6"
end

