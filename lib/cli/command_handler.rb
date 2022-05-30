# frozen_string_literal: true

require "cli/command"
require "yaml"

module RailsInteractive
  class CLI
    # Commands class for the interactive CLI module
    class CommandHandler
      def initialize
        @commands = Command.new.all
      end

      def handle_multi_options(options, dependencies = nil)
        handle_dependencies(dependencies)
        options.each { |option| system("bin/rails app:template LOCATION=templates/setup_#{option}.rb") }
      end

      def handle_option(option, dependencies = nil)
        handle_dependencies(dependencies)
        system("bin/rails app:template LOCATION=templates/setup_#{option}.rb")
      end

      def handle_dependencies(dependencies)
        dependencies&.each do |dependency|
          puts ">> Dependency Detected: #{dependency} "
          system("bin/rails app:template LOCATION=templates/setup_#{dependency}.rb")
        end
      end
    end
  end
end
