# frozen_string_literal: true

require "colorize"

module RailsInteractive
  # Utils class for the interactive CLI module
  class Message
    def self.greet
      render_ascii
      puts "Welcome to Rails Interactive CLI".colorize(:yellow)
    end

    def self.help
      puts "bin/interactive new - Create a new Rails Project".colorize(:yellow)
      puts "bin/interactive help - List all commands".colorize(:yellow)
      exit
    end

    def self.render_ascii
      # rubocop:disable Naming/HeredocDelimiterNaming
      puts <<-'EOF'
  _____       _ _     _____       _                      _   _
 |  __ \     (_) |   |_   _|     | |                    | | (_)
 | |__) |__ _ _| |___  | |  _ __ | |_ ___ _ __ __ _  ___| |_ ___   _____
 |  _  // _` | | / __| | | | '_ \| __/ _ \ '__/ _` |/ __| __| \ \ / / _ \
 | | \ \ (_| | | \__ \_| |_| | | | ||  __/ | | (_| | (__| |_| |\ V /  __/
 |_|  \_\__,_|_|_|___/_____|_| |_|\__\___|_|  \__,_|\___|\__|_| \_/ \___|


      EOF
      # rubocop:enable Naming/HeredocDelimiterNaming
    end

    def self.prepare
      puts ""
      puts "Project created successfully ✅".colorize(:green)
      puts "Go to your project folder and ready to go 🎉".colorize(:green)
      rails_commands
    end

    def self.rails_commands
      puts "You can run several commands:".colorize(:green)

      puts "Starts the webpack development server".colorize(:cyan)
      puts "> bin/webpack-dev-server".colorize(:yellow)

      puts "Starts the rails server".colorize(:cyan)
      puts "> bin/rails s or bin/rails server".colorize(:yellow)

      puts "Starts the rails console".colorize(:cyan)
      puts "> bin/rails c or bin/rails console".colorize(:yellow)
    end
  end
end
