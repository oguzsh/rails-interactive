# frozen_string_literal: true

run "rails db:prepare"
run "bundle add rails_admin"

Bundler.with_unbundled_env { run "bundle install" }

rails_command("generate rails_admin:install")

puts "RailsAdmin is installed! You can go to your admin panel at /admin"
