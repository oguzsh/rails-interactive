# frozen_string_literal: true

gem_group :development do
  gem "better_errors"
  gem "binding_of_caller"
end

Bundler.with_unbundled_env { run "bundle install" }
