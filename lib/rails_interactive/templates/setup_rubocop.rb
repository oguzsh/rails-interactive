# frozen_string_literal: true

gem_group :development do
  gem "rubocop", require: false
end

Bundler.with_unbundled_env { run "bundle install" }

run "rubocop --auto-gen-config"
run "bundle binstubs rubocop"
