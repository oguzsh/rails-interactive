# frozen_string_literal: true

run "bundle add bullet --group 'development'"

Bundler.with_unbundled_env { run "bundle install" }

run "bundle exec rails g bullet:install"
