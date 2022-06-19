# frozen_string_literal: true

def package?(package)
  require "json"

  file = File.open("package.json") if File.file?("package.json")

  packages = JSON.parse(file.read) if file

  packages["dependencies"].include?(package) if packages
end

run "bundle add tailwindcss-rails"

if package?("react")
  run "rm Procfile.dev"
  run "rm bin/dev"
end

rails_command "tailwindcss:install"

if package?("react")
  run "rm Procfile.dev"
  run "echo 'web: bin/rails server -p 3000\njs: yarn build --watch\ncss: bin/rails tailwindcss:watch' > Procfile.dev"
end
