# frozen_string_literal: true

require "yaml"

module RailsInteractive
  class CLI
    # Categories class for the interactive CLI module
    class Category
      def initialize
        @categories = YAML.load_file("#{__dir__}/config/categories.yml").uniq
      end

      def all
        @categories.sort_by { |category| category["weight"] }
      end
    end
  end
end
