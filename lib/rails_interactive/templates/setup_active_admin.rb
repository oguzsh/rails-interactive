run "bundle add activeadmin"
run "bundle add bcrypt"
Bundler.with_unbundled_env { run "bundle" }

if yes?("Do you want to install Devise?(prefered)[y/n]") && !defined?(Devise)
  run "rails db:create"
  run "bundle add devise"
  rails_command "generate active_admin:install"
else
  model = ask("What is the user model you want to use for Active Admin? (ex: User)")
  rails_command "generate active_admin:install #{model.capitalize}" if model
end
rails_command "generate active_admin:webpacker"
rails_command "db:migrate"

while yes?("Do you want to add an other model to ActiveAdmin?[y/n]") do
  model = ask('Model name (ex: Post or MyPost):')
  if model
    rails_command "g active_admin:resource #{model}"
  end
end
