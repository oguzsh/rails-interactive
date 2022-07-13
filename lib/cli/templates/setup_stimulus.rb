# frozen_string_literal: true

run "bundle add turbo-rails"
run "bundle add stimulus-rails"

Bundler.with_unbundled_env { run "bundle install" }

rails_command "turbo:install stimulus:install"
