# frozen_string_literal: true

source "https://rubygems.org"

eval_gemfile "Gemfile.devtools"

gemspec

unless ENV["CI"]
  gem "yard", require: false
end

gem "hanami-view",     github: "hanami/view",     branch: "main", require: false
gem "hanami-devtools", github: "hanami/devtools", branch: "main", require: false

gem "rack", "~> 2.2"
gem "rack-test", "~> 1.1"
gem "dry-configurable", "~> 1.1"
gem "dry-inflector", "~> 1.0"

group :test do
  gem "rspec", "~> 3.9"
end
