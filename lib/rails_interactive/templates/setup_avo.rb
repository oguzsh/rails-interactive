# frozen_string_literal: true

run "rails db:prepare"
run "bundle add avo"

Bundler.with_unbundled_env { run "bundle install" }

rails_command("generate avo:install")

puts "Avo is installed! You can go to http://localhost:3000/avo for next steps"
