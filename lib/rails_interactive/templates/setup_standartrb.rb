# frozen_string_literal: true

gem_group :development, :test do
  gem "standart"
end

Bundler.with_unbundled_env { run "bundle install" }

puts "You can then run Standard from the command line with:"
puts "bundle exec standardrb"
