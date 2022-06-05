# frozen_string_literal: true

gem_group :development, :test do
  gem "capybara"
end

Bundler.with_unbundled_env { run "bundle install" }

if defined? RSpec
  inject_into_file "spec/spec_helper.rb", before: "RSpec.configure do |config|" do
    <<~RB
      require 'capybara/rspec'
    RB
  end
elsif defined? MiniTest && !defined? RSpec
  inject_into_file "test/test_helper.rb", before: "class ActiveSupport::TestCase" do
    <<~RB
      require 'capybara/rails'
      require 'capybara/minitest'
    RB
  end
else
  puts "No test framework detected or related test framework does not exist in RailsInteractive"
end
