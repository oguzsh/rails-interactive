# frozen_string_literal: true

run 'bundle add letter_opener --group "development"'

Bundler.with_unbundled_env { run "bundle install" }

inject_into_file "config/environments/development.rb", after: "config.action_mailer.perform_caching = false\n" do
  <<-RUBY

  config.action_mailer.delivery_method = :letter_opener
  config.action_mailer.perform_deliveries = true
  RUBY
end

puts "Letter Opener is now installed!"
