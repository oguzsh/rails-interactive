# frozen_string_literal: true

require "tty-prompt"

module Interactive
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
      else
        puts "Invalid parameter"
      end
    end

    def create
      project_name = @prompt.ask("What is your project name? ", required: true)
    end

    def greet
      render_ascii
      puts "Welcome to Rails Interactive CLI - #{Interactive::VERSION}"
    end
  end
end
