# frozen_string_literal: true

require "fileutils"

module RailsInteractive
  class CLI
    class Utils
      def self.humanize(value)
        return nil if value.nil?

        value
          .gsub(/^[\s_]+|[\s_]+$/, "")
          .gsub(/[_\s]+/, " ")
          .gsub(/^[a-z]/, &:upcase)
      end

      def self.go_to_project_directory(project_name)
        FileUtils.rm_rf("./#{project_name}/templates")
      end

      def self.remove_templates(project_name)
        Dir.chdir "./#{project_name}"
      end

      def self.copy_templates_to_project(project_name)
        FileUtils.cp_r "#{__dir__}/rails_interactive/templates", "./#{project_name}"

        go_to_project_directory(project_name)
      end

      def handle_multi_options(multi_options)
        multi_options.each do |value|
          system("bin/rails app:template LOCATION=templates/setup_#{value}.rb")
        end
      end

      def handle_option(option)
        system("bin/rails app:template LOCATION=templates/setup_#{option}.rb")
      end

      def self.sign_project
        file = "README.md"
        msg = "\n> This project was generated by [Rails Interactive CLI](https://github.com/oguzsh/rails-interactive)"
        File.write(file, msg, mode: "a+")
      end
    end
  end
end