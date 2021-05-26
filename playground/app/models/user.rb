class User < ApplicationRecord
  include Authcat::Account

  has_many :sessions, dependent: :delete_all

  ENV['LOCKBOX_MASTER_KEY'] = '0000000000000000000000000000000000000000000000000000000000000000'

  identifier :email, type: :email
  identifier :phone_number, type: :phone_number
  # identifier :github_oauth_token, type: :token
  # identifier :google_oauth_token, type: :token

  has_password
  has_one_time_password
  has_recovery_codes

  concerning :UpdateProfile do
    included do
      define_model_callbacks :update_profile
    end

    def update_profile(attributes = {})
      self.attributes = attributes
      valid?(:update_profile) && run_callbacks(:update_profile) { save }
    end
  end

  include Authcat::Account::UpdatePassword[:password]
  include Authcat::Account::UpdateOneTimePassword[:one_time_password]
end
