# frozen_string_literal: true

def file_contains?(filename, string)
  File.foreach(filename).detect { |line| line.include?(string) }
end

run "bundle add sidekiq"
run "bundle add redis" unless file_contains? "Gemfile", "Gem 'redis'"

Bundler.with_unbundled_env { run "bundle install" }

# rubocop:disable Naming/HeredocDelimiterNaming
application do
  <<~EOF
    config.active_job.queue_adapter = :sidekiq
  EOF
end

inject_into_file "config/routes.rb" do
  <<~EOF
    require "sidekiq/web"
    if Rails.env.production?
      Sidekiq::Web.use Rack::Auth::Basic do |username, password|
        ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(username), ::Digest::SHA256.hexdigest(ENV["SIDEKIQ_USERNAME"])) &
          ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(password), ::Digest::SHA256.hexdigest(ENV["SIDEKIQ_PASSWORD"]))
      end
    end
  EOF
end
# rubocop:enable Naming/HeredocDelimiterNaming

route 'mount Sidekiq::Web => "/sidekiq"'
