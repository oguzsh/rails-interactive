# frozen_string_literal: true

run "bundle add sassc-rails"
Bundler.with_unbundled_env { run "bundle" }
