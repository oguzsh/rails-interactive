# frozen_string_literal: true

def file_contains?(filename, string)
  File.foreach(filename).detect { |line| line.include?(string) }
end

run "bundle add activeadmin"
run "bundle add bcrypt"
Bundler.with_unbundled_env { run "bundle" }

run "rails db:prepare"
if !file_contains?("Gemfile", "Gem 'devise'") && yes?("Do you want to install Devise?(prefered)[y/n]")
    run "bundle add devise"
    rails_command "generate active_admin:install"
else
  model = ask("What is the user model you want to use for Active Admin? (ex: User)")
  rails_command "generate active_admin:install #{model.capitalize}" if model
end
rails_command "db:migrate"
