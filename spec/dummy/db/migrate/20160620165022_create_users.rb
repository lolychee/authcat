# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    enable_extension :hstore

    create_table :users do |t|
      t.string :email,            null: false
      t.string :password_digest,  null: false

      t.boolean :otp_required,    null: false, default: false
      t.string :otp_secret
      t.string :otp_backup_codes_digest, array: true
      t.datetime :last_otp_at

      t.timestamps null: false
    end
  end
end
