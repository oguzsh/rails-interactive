run "bundle add devise"
Bundler.with_unbundled_env { run "bundle install" }

rails_command "generate devise:install"

run "rails generate devise User"
run "rails db:create"
run "rails db:migrate"
