# frozen_string_literal: true

require "fileutils"

run "bundle add omniauth"

run "bundle install"

devise_model_name = File.read("devise-model.txt")
FileUtils.rm("devise-model.txt")

# rubocop:disable Layout/LineLength
rails_command "generate model identity #{devise_model_name}:references provider:string:index uid:string:index token:string:index refresh_token:string:index"
# rubocop:enable Layout/LineLength

rails_command "generate migration AddIdentityTo#{devise_model_name.capitalize}s identities_count:integer"

rails_command "db:migrate"

inject_into_file "config/routes.rb", after: "devise_for :#{devise_model_name}s\n" do
  " # devise_for :#{devise_model_name}s, controllers: { omniauth_callbacks: 'omniauth' }"
end

inject_into_file "app/models/#{devise_model_name}.rb", after: ":database_authenticatable, " do
  ":omniauthable, "
end

inject_into_file "app/models/identity.rb", after: "belongs_to :#{devise_model_name}" do
  ", counter_cache: true"
end

inject_into_file "app/models/#{devise_model_name}.rb",
                 after: "class #{devise_model_name.capitalize} < ApplicationRecord\n" do
  # rubocop:disable Naming/HeredocDelimiterNaming
  <<-EOF
  has_many :identities, dependent: :destroy

  def self.from_omniauth(auth)
    if auth.present? && auth.provider.present? && auth.uid.present?
      identity = Identity.where(provider: auth.provider, uid: auth.uid).first_or_initialize
      if auth.credentials.present?
        identity.token = auth.credentials.token
        identity.refresh_token = auth.credentials.refresh_token
      end
      if identity.#{devise_model_name}.nil? && auth.info.email.present?
        user = #{devise_model_name}.where(email: auth.info.email).first_or_initialize
        user.name = auth.info.name
        user.password = Devise.friendly_token if user.new_record?
        user.save!
        identity.#{devise_model_name} = user
      end
      identity.save!
      identity.#{devise_model_name}
    end
  end

  EOF
  # rubocop:enable Naming/HeredocDelimiterNaming
end

file "app/controllers/omniauth_controller.rb", <<~CODE
  class OmniauthController < Devise::OmniauthCallbacksController

  end
CODE
# rubocop:disable Layout/LineLength
puts "IMPORTANT: Add devise_for :#{devise_model_name}s, controllers: { omniauth_callbacks: 'omniauth' } to your routes.rb"
# rubocop:enable Layout/LineLength
