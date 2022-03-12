# frozen_string_literal: true

require "interactive/prompt"
require "interactive/utils"

module Interactive
  # CLI class for the interactive CLI module
  class CLI
    def initialize
      @inputs = {}
    end

    def perform(key)
      case key
      when "new"
        Utils.greet
        initialize_project
      when "help"
        Utils.help
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

      create_project
    end

    def create_project
      system(parse_inputs)
    end

    def parse_inputs
      base = "rails new"
      cmd = ""

      @inputs.each { |_key, value| cmd += "#{value} " }

      "#{base} #{cmd}".strip!
    end
  end
end
