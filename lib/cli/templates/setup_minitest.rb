# frozen_string_literal: true

run "bundle add minitest"

Bundler.with_unbundled_env { run "bundle install" }
