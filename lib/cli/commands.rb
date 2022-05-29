# frozen_string_literal: true

require "yaml"

module RailsInteractive
  class CLI
    # Commands class for the interactive CLI module
    class Commands
      def initialize
        @commands = YAML.load_file("lib/cli/commands.yml").uniq
      end

      def all
        @commands
      end

      def find_by_identifier(identifier)
        @commands.find { |command| command["identifier"] == identifier }
      end
    end
  end
end
