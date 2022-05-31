# frozen_string_literal: true

run "spring stop"

gem_group :development, :test do
  gem "rspec-rails"
end

Bundler.with_unbundled_env { run "bundle install" }

rails_command "generate rspec:install"

puts "RSpec is installed!"
