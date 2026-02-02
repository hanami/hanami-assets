# frozen_string_literal: true

lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "hanami/assets/version"

Gem::Specification.new do |spec|
  spec.name          = "hanami-assets"
  spec.version       = Hanami::Assets::VERSION
  spec.authors       = ["Hanakai team"]
  spec.email         = ["info@hanakai.org"]
  spec.summary       = "Assets management"
  spec.description   = "Assets management for Ruby web applications"
  spec.homepage      = "http://hanamirb.org"
  spec.license       = "MIT"

  spec.files         = `git ls-files -- lib/* bin/* CHANGELOG.md LICENSE.md README.md hanami-assets.gemspec`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.metadata["rubygems_mfa_required"] = "true"
  spec.required_ruby_version = ">= 3.2"

  spec.add_dependency "zeitwerk", "~> 2.6"
end
