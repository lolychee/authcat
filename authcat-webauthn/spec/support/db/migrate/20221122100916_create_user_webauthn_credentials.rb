# frozen_string_literal: true

class CreateUserWebAuthnCredentials < ActiveRecord::Migration[6.1]
  def change
    create_table :user_webauthn_credentials do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.string :webauthn_id, null: false
      t.string :name, null: false
      t.string :public_key, null: false
      t.integer :sign_count, null: false
      t.string :challenge

      t.timestamps
    end
    add_index :user_webauthn_credentials, %i[user_id webauthn_id], unique: true
  end
end
