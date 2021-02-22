class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      # t.string :email, index: { unique: true }
      t.string :email_ciphertext
      t.string :email_bidx, index: { unique: true }
      t.string :email_otp_secret

      # t.string :phone_number, index: { unique: true }
      t.string :phone_number_ciphertext
      t.string :phone_number_bidx, index: { unique: true }
      t.string :phone_number_otp_secret

      t.string :password_digest
      t.string :password_otp_secret

      t.string :backup_codes_digest, array: true

      t.string :github_id
      t.string :google_id

      t.string :name, null: false

      t.timestamps
    end
  end
end
