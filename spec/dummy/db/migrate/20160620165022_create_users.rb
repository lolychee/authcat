# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    enable_extension :hstore

    create_table :users do |t|
      t.string :email,            null: false
      t.string :password_digest,  null: false

      t.string :tfa_secret
      t.string :tfa_backup_codes_digest, array: true
      t.datetime :last_tfa_at
      t.datetime :last_sign_in_at

      t.timestamps null: false
    end
  end
end
