# frozen_string_literal: true

run "rails db:prepare"
run "bundle add graphql"

Bundler.with_unbundled_env { run "bundle install" }

rails_command("generate graphql:install")

puts "GraphQL is installed!"
