# frozen_string_literal: true

run "bundle add omniauth"

run "bundle install"

# rubocop:disable Layout/LineLength
rails_command "generate model identity user:references provider:string:index uid:string:index token:string:index refresh_token:string:index"
# rubocop:enable Layout/LineLength

rails_command "generate migration AddIdentityToUsers identities_count:integer"

rails_command "db:migrate"

inject_into_file "config/routes.rb", after: "devise_for :users\n" do
  " # devise_for :users, controllers: { omniauth_callbacks: 'omniauth' }"
end

inject_into_file "app/models/user.rb", after: ":database_authenticatable, " do
  ":omniauthable, "
end

inject_into_file "app/models/identity.rb", after: "belongs_to :user" do
  ", counter_cache: true"
end

inject_into_file "app/models/user.rb", after: "class User < ApplicationRecord\n" do
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
      if identity.user.nil? && auth.info.email.present?
        user = User.where(email: auth.info.email).first_or_initialize
        user.name = auth.info.name
        user.password = Devise.friendly_token if user.new_record?
        user.save!
        identity.user = user
      end
      identity.save!
      identity.user
    end
  end

  EOF
  # rubocop:enable Naming/HeredocDelimiterNaming
end

file "app/controllers/omniauth_controller.rb", <<~CODE
  class OmniauthController < Devise::OmniauthCallbacksController

  end
CODE

puts "IMPORTANT: Add devise_for :users, controllers: { omniauth_callbacks: 'omniauth' } to your routes.rb"