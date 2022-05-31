# frozen_string_literal: true

run "bundle add cancancan"

Bundler.with_unbundled_env { run "bundle install" }

rails_command "generate cancan:ability"
