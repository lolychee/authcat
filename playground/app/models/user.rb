class User < ApplicationRecord
  include Authcat::Identity
  include Authcat::Password::HasPassword
  include Authcat::MultiFactor

  ENV['LOCKBOX_MASTER_KEY'] = '0000000000000000000000000000000000000000000000000000000000000000'

  identifier :email, type: :email
  has_one_time_password :email_otp

  identifier :phone_number, type: :phone_number
  has_one_time_password :phone_number_otp

  has_password
  has_one_time_password :password_otp
  # serialize :backup_codes_digest, Array if connection.adapter_name == 'SQLite'
  has_backup_codes

  identifier :github_id, type: :token
  identifier :google_id, type: :token
end
