# frozen_string_literal: true

run "bundle add pundit"

puts "Add - Pundit module to Application Controller"
puts ""

inject_into_file "app/controllers/application_controller.rb",
                 after: "class ApplicationController < ActionController::Base\n" do
  "  include Pundit\n"
end

puts "Run - Pundit Generator"

rails_command("generate pundit:install")
