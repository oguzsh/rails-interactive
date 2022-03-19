# frozen_string_literal: true

require "rails-interactive/prompt"
require "rails-interactive/message"

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
      @inputs[:name] = Prompt.new("Enter the name of the project: ", "ask", required: true).perform

      types = { "App" => "", "API" => "--api" }
      @inputs[:type] = Prompt.new("Choose project type: ", "select", types, required: true).perform

      database_types = { "PostgreSQL" => "-d postgresql", "MySQL" => "-d mysql", "SQLite" => "" }
      @inputs[:database] = Prompt.new("Choose project's database: ", "select", database_types, required: true).perform

      create
    end

    def create
      # Install gems
      system("bin/setup")
      # Create project
      system(setup)
      # Prepare project requirements and give instructions
      Message.prepare
    end

    def setup
      base = "rails new"
      cmd = ""

      @inputs.each { |_key, value| cmd += "#{value} " }

      "#{base} #{cmd}".strip!
    end
  end
end
