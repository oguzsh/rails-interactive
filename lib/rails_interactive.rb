# frozen_string_literal: true

require "cli/prompt"
require "cli/message"
require "cli/command"
require "cli/category"
require "cli/utils"
require "cli/command_handler"

module RailsInteractive
  # CLI class for the interactive CLI module
  class CLI
    def initialize
      @inputs = {}
      @commands = Command.new
      @categories = Category.new
      @handler = CommandHandler.new
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

    private

    def categories_with_commands
      @categories.all.each do |category|
        commands = []
        @commands.all.each { |command| commands << command if command["category"] == category["name"] }
        category["commands"] = commands
      end
    end

    def initialize_project
      name
      type
      database

      categories_with_commands.each do |category|
        category_name = category["name"]
        category_type = category["type"]
        category_command_list = create_command_list(category["commands"], category_type)

        @inputs[category_name.to_sym] =
          Prompt.new("Choose #{Utils.humanize(category_name)} gems: ", category_type.to_s,
                     category_command_list).perform
      end

      create_project
    end

    def setup
      base = "rails new"
      cmd = ""

      @inputs.first(3).each { |_key, value| cmd += "#{value} " unless value.empty? }

      "#{base} #{cmd} -q --skip-hotwire"
    end

    def create_project
      # Install gems
      system("bin/setup")
      # Create project
      system(setup)
      # Install gems
      install_gems
      # Prepare project requirements and give instructions
      Utils.sign_project
      Message.prepare
    end

    def create_command_list(commands, category_type)
      return nil if commands.nil? || category_type.nil?

      list = category_type == "select" ? {} : []

      commands.each do |command|
        if list.is_a?(Hash)
          list["None"] = nil
          list[command["name"]] = command["identifier"]
        else
          list << command["identifier"]
        end
      end

      list
    end

    def install_gems
      # Copy template files to project folder
      Utils.copy_templates_to_project(@inputs[:name])

      @inputs.each do |key, value|
        next if %i[name type database].include?(key) || value.is_a?(Array) && value.empty? || value.nil?

        dependencies = @commands.dependencies(value)

        @handler.handle_multi_options(value, dependencies) if value.is_a?(Array)
        @handler.handle_option(value, dependencies) if value.is_a?(String)
      end

      # Prepare database for project everytime
      system("bin/rails db:prepare")

      # Remove templates folder from project folder
      Utils.remove_templates(@inputs[:name])
    end

    def name
      @inputs[:name] = Prompt.new("Project name: ", "ask", required: true).perform
    end

    def type
      types = { "App" => "", "Api" => "--api" }
      @inputs[:type] = Prompt.new("Type: ", "select", types, required: true).perform
    end

    def database
      database_types = { "PostgreSQL" => "-d postgresql", "MySQL" => "-d mysql", "SQLite" => "" }

      @inputs[:database] = Prompt.new("Database: ", "select", database_types, required: true).perform
    end

    def admin_panel
      admin_panel = { "ActiveAdmin" => "active_admin" }

      @inputs[:admin_panel] =
        Prompt.new("Choose project admin panel: ", "select", admin_panel).perform
    end
  end
end
