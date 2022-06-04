# frozen_string_literal: true

require "cli/command"
require "yaml"

module RailsInteractive
  class CLI
    # Commands class for the interactive CLI module
    class CommandHandler
      def initialize
        @commands = Command.new.all
        @installed_commands = []
        @installed_dependencies = []
      end

      def handle_multi_options(options, dependencies = nil)
        handle_dependencies(dependencies)

        options.each do |option|
          @installed_commands << option
          system("bin/rails app:template LOCATION=templates/setup_#{option}.rb")
        end
      end

      def handle_option(option, dependencies = nil)
        @installed_commands << option
        handle_dependencies(dependencies)

        system("bin/rails app:template LOCATION=templates/setup_#{option}.rb")
      end

      def handle_dependencies(dependencies)
        dependencies&.each do |dependency|
          next if duplicated_gem?(dependency)

          puts ">> Dependency Detected: #{dependency} "
          @installed_dependencies << dependency

          system("bin/rails app:template LOCATION=templates/setup_#{dependency}.rb")
        end
      end

      private

      def duplicated_gem?(option)
        @installed_commands.include?(option) || @installed_dependencies.include?(option)
      end
    end
  end
end
