# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    enable_extension :hstore

    create_table :users do |t|
      t.string :email, null: false
      t.string :otp_secret
      t.string :backup_codes_digest
      t.string :security_questions

      t.datetime :otp_last_used_at

      t.timestamps null: false
    end
  end
end
