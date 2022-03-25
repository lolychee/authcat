# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    enable_extension :hstore

    create_table :users do |t|
      t.string :email, null: false
      t.string :one_time_password

      t.string :recovery_codes

      t.string :security_questions

      t.string :webauthn_id
      t.string :webauthn_public_key
      t.integer :webauthn_sign_count

      t.timestamps null: false
    end
  end
end
