# frozen_string_literal: true

run "bundle add kaminari"

Bundler.with_unbundled_env { run "bundle install" }

puts "Kaminari is installed!"
