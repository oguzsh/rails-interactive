# frozen_string_literal: true

require "tty-prompt"

module Interactive
  # CLI class for the interactive CLI module
  class CLI
    def initialize
      @prompt = TTY::Prompt.new
    end

    def process_argv(option)
      case option
      when "new"
        greet
        create
        puts "Project creating...."
      when "help"
        menu
      else
        puts "Invalid parameter"
      end
    end

    def create
      project_name = @prompt.ask("What is your project name? ", required: true)

      project_types = %w[App API]
      project_type = @prompt.select("Choose project type? ", project_types, required: true)

      db_types = %w[SQLite MySQL PostgreSQL]
      db_type = @prompt.select("Choose database? ", db_types, required: true)
    end

    def greet
      render_ascii
      puts "Welcome to Rails Interactive CLI - #{Interactive::VERSION}"
    end

    def render_ascii
      # rubocop:disable Naming/HeredocDelimiterNaming
      puts <<-'EOF'
  ___       _                      _   _           ____       _ _
 |_ _|_ __ | |_ ___ _ __ __ _  ___| |_(_)_   _____|  _ \ __ _(_) |___
  | || '_ \| __/ _ \ '__/ _` |/ __| __| \ \ / / _ \ |_) / _` | | / __|
  | || | | | ||  __/ | | (_| | (__| |_| |\ V /  __/  _ < (_| | | \__ \
 |___|_| |_|\__\___|_|  \__,_|\___|\__|_| \_/ \___|_| \_\__,_|_|_|___/

      EOF
      # rubocop:enable Naming/HeredocDelimiterNaming
    end

    def menu
      puts "bin/interactive new - Create a new Rails Project"
      puts "bin/interactive help - List all commands"
      exit
    end
  end
end
