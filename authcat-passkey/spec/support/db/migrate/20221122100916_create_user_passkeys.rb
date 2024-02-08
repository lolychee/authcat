# frozen_string_literal: true

class CreateUserPasskeys < ActiveRecord::Migration[6.1]
  def change
    create_table :passkeys do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.string :webauthn_id, index: { unique: true }
      t.string :title
      t.string :public_key
      t.integer :sign_count
      t.string :challenge

      t.timestamps
    end
  end
end
