run "bundle add activeadmin"
run "bundle add bcrypt"
Bundler.with_unbundled_env { run "bundle" }

if yes?("Do you want to install Devise?(prefered)[y/n]") && !defined?(Devise)
  run "rails db:prepare"
  run "bundle add devise"
  rails_command "generate active_admin:install"
else
  run "rails db:prepare"
  model = ask("What is the user model you want to use for Active Admin? (ex: User)")
  rails_command "generate active_admin:install #{model.capitalize}" if model
end
rails_command "db:migrate"
