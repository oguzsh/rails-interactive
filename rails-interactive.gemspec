# frozen_string_literal: true

require_relative "lib/cli/version"

Gem::Specification.new do |spec|
  spec.name          = "rails-interactive"
  spec.version       = RailsInteractive::CLI::VERSION
  spec.authors       = ["Oguzhan Ince"]
  spec.email         = ["oguzhan824@gmail.com"]

  spec.summary       = "The gem for setup rails development with interactive mode"
  spec.homepage      = "https://github.com/oguzsh/rails-interactive"
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 2.7.5"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/oguzsh/rails-interactive"
  spec.metadata["changelog_uri"] = "https://github.com/oguzsh/rails-interactive/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.executables   = spec.files.grep(%r{\Abin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  spec.add_development_dependency "bundler"
  spec.add_development_dependency "byebug", "~> 11.1.2"
  spec.add_development_dependency "colorize"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rubocop"
  spec.add_development_dependency "yaml"

  spec.add_dependency "tty-prompt"

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end
