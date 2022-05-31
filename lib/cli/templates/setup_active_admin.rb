# frozen_string_literal: true

def active_admin_install_without_devise
  model = ask("What is the user model you want to use for Active Admin? (ex: Admin)")
  rails_command "generate active_admin:install #{model.capitalize}" if model
end

def active_admin_install_with_devise
  rails_command "generate active_admin:install"
end

run "bundle add activeadmin"
run "bundle add bcrypt"
Bundler.with_unbundled_env { run "bundle" }

if !defined?(Devise)
  active_admin_install_without_devise
else
  active_admin_install_with_devise
end
rails_command "db:migrate"
