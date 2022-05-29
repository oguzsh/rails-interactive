# frozen_string_literal: true

run 'bundle add awesome_print --group "development"'
Bundler.with_unbundled_env { run "bundle install" }
