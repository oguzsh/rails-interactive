# frozen_string_literal: true

run "bundle add activeadmin"
run "bundle add bcrypt"
Bundler.with_unbundled_env { run "bundle" }

rails_command "generate active_admin:install"
rails_command "db:migrate"
