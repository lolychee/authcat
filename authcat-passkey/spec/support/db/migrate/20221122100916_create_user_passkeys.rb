# frozen_string_literal: true

class CreateUserPasskeys < ActiveRecord::Migration[6.1]
  def change
    create_table :user_passkeys do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.string :webauthn_id, null: false
      t.string :title, null: false
      t.string :public_key, null: false
      t.integer :sign_count, null: false
      t.string :challenge

      t.timestamps

      t.index %i[user_id attribute_name]
    end
  end
end
