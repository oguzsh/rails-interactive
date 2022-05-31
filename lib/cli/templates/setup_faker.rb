# frozen_string_literal: true

run "bundle add faker --group 'development' 'test'"

Bundler.with_unbundled_env { run "bundle install" }
