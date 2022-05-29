# frozen_string_literal: true

require "yaml"

module RailsInteractive
  class CLI
    # Categories class for the interactive CLI module
    class Categories
      def initialize
        @categories = YAML.load_file("lib/cli/categories.yml").uniq
      end

      def all
        @categories.sort_by { |category| category["weight"] }
      end
    end
  end
end
