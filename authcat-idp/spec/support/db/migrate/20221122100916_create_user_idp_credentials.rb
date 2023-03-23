# frozen_string_literal: true

class CreateUserIdPCredentials < ActiveRecord::Migration[6.1]
  def change
    create_table :user_idp_credentials do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.string :provider, null: false
      t.string :token, null: false
      t.string :metadata, null: false

      t.timestamps
    end
    add_index :user_idp_credentials, %i[provider user_id], unique: true
    add_index :user_idp_credentials, %i[provider token], unique: true
  end
end
