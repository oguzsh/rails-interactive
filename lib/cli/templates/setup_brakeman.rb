# frozen_string_literal: true

run 'bundle add brakeman --group "development"'
Bundler.with_unbundled_env { run "bundle install" }
run "bundle binstubs brakeman"
run "bin/brakeman"
