class User < ApplicationRecord
  include Authcat::Identity
  include Authcat::MultiFactor

  has_many :sessions

  ENV['LOCKBOX_MASTER_KEY'] = '0000000000000000000000000000000000000000000000000000000000000000'

  identifier :email, type: :email#, factors: %i[password verification_code]
  identifier :phone_number, type: :phone_number#, factors: %i[password verification_code]
  # identifier :github_oauth_token, type: :token
  # identifier :google_oauth_token, type: :token

  has_password
  has_one_time_password
  has_backup_codes

end
