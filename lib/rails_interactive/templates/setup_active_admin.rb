# frozen_string_literal: true
run "bundle add activeadmin"
run "bundle add bcrypt"
Bundler.with_unbundled_env { run "bundle" }

if !file_contains?("Gemfile", "Gem 'devise'")
  active_admin_install_with_devise
else
  active_admin_install_without_devise
end
rails_command "db:migrate"


def file_contains?(filename, string)
  File.foreach(filename).detect { |line| line.include?(string) }
end

def active_admin_install_without_devise
  model = ask("What is the user model you want to use for Active Admin? (ex: Admin)")
  rails_command "generate active_admin:install #{model.capitalize}" if model
end

def active_admin_install_with_devise
  system("bin/rails app:template LOCATION=templates/setup_devise.rb")
  rails_command "generate active_admin:install"
end