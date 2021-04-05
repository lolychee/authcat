class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      # t.string :email, index: { unique: true }
      t.string :email_ciphertext
      t.string :email_bidx, index: { unique: true }

      # t.string :phone_number, index: { unique: true }
      t.string :phone_number_ciphertext
      t.string :phone_number_bidx, index: { unique: true }

      t.string :password_digest
      t.string :one_time_password_secret
      t.datetime :one_time_password_last_used_at

      t.string :backup_codes_digest, array: true

      t.string :github_oauth_token
      t.string :google_oauth_token

      t.string :name

      t.timestamps
    end
  end
end
