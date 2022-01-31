# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :email, index: { unique: true }
      # t.string :email_ciphertext
      # t.string :email_bidx, index: { unique: true }

      t.string :phone_number, index: { unique: true }
      # t.string :phone_number_ciphertext
      # t.string :phone_number_bidx, index: { unique: true }

      t.string :password
      t.string :one_time_password

      t.string :recovery_codes

      t.string :github_oauth_token
      t.string :google_oauth_token

      t.string :name

      t.timestamps
    end
  end
end
