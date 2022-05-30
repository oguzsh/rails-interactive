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

      def handle_multi_options_(options, dependencies = nil)
        handle_dependencies(dependencies) if dependencies
        options.each { |option| system("bin/rails app:template LOCATION=templates/setup_#{option}.rb") }
      end

      def handle_option(option, dependencies = nil)
        handle_dependencies(dependencies) if dependencies
        system("bin/rails app:template LOCATION=templates/setup_#{option}.rb")
      end

      def handle_dependencies(_options)
        dependencies.each do |dependency|
          system("bin/rails app:template LOCATION=templates/setup_#{dependency}.rb")
        end
      end
    end
  end
end
