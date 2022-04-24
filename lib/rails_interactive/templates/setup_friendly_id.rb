# frozen_string_literal: true

def ask_with_default(prompt, default)
  value = ask("#{prompt} (default: #{default})")
  value.present? ? value : default
end

run "bundle add 'friendly_id'"

rails_command "generate friendly_id"

while yes?("Do you want to use Friendly ID with an existing model? (y/n)")
  model_name = ask_with_default("Model Name:", "Postr")
  attribute = ask_with_default("Attribute:", "name")
  next unless model_name && attribute

  # We generate a migration to add the friendly id slug column.
  generate(:migration, "AddSlugTo#{model_name.titleize.pluralize}", "slug:uniq")
  string = <<~RUBY
    extend FriendlyId
    friendly_id :#{attribute}, use: :slugged
  RUBY
  # Inject the friendly id methods into the class.
  inject_into_file "app/models/#{model_name.downcase}.rb", string,
                   after: "class #{model_name.titleize} < ApplicationRecord\n"
end
