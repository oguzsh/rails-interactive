# frozen_string_literal: true

run "bundle add devise"
Bundler.with_unbundled_env { run "bundle install" }

rails_command "generate devise:install"

model_name = ask("What do you want to call your Devise model?")
model_name = model_name.empty? ? "user" : model_name

File.open("devise-model.txt", "w") { |f| f.write(model_name) }

run "rails generate devise #{model_name.capitalize}"
run "rails db:prepare"
run "rails db:migrate"
