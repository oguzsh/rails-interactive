# frozen_string_literal: true

require "rails_interactive/prompt"
require "rails_interactive/message"
require "fileutils"

module RailsInteractive
  # CLI class for the interactive CLI module
  class CLI
    def initialize
      @inputs = {}
    end

    def perform(key)
      case key
      when "new"
        Message.greet
        initialize_project
      when "help"
        Message.help
      else
        puts "Invalid parameter"
      end
    end

    def initialize_project
      name
      type
      database
      css_frameworks

      create
    end

    def create
      # Install gems
      system("bin/setup")

      # Create project
      system(setup)

      # Prepare project requirements and give instructions
      Dir.chdir "./#{@inputs[:name]}"
      sign_project
      Message.prepare
    end

    def setup
      base = "rails new"
      cmd = ""

      @inputs.each { |_key, value| cmd += "#{value} " }

      "#{base} #{cmd}".strip!
    end

    private

    def name
      @inputs[:name] = Prompt.new("Enter the name of the project: ", "ask", required: true).perform
    end

    def type
      types = { "App" => "", "API" => "--api" }
      @inputs[:type] = Prompt.new("Choose project type: ", "select", types, required: true).perform
    end

    def database
      database_types = { "PostgreSQL" => "-d postgresql", "MySQL" => "-d mysql", "SQLite" => "" }

      @inputs[:database] = Prompt.new("Choose project's database: ", "select", database_types, required: true).perform
    end

    def css_frameworks
      css_frameworks = { "None" => "", "Bootstrap" => "--css=bootstrap", "Tailwind" => "--css=tailwind" }

      @inputs[:css_framework] =
        Prompt.new("Choose project's CSS framework: ", "select", css_frameworks, required: true).perform
    end

    def sign_project
      file = "README.md"
      msg = "\n> This project was generated by [Rails Interactive CLI](https://github.com/oguzsh/rails-interactive)"
      File.write(file, msg, mode: "a+")
    end
  end
end
