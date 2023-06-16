# frozen_string_literal: true

class CreateUserIdPCredentials < ActiveRecord::Migration[6.1]
  def change
    create_table :user_idp_credentials do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.string :provider, null: false
      t.string :token, null: false
      t.string :metadata, null: false

      t.timestamps

      t.index %i[user_id provider token], unique: true
    end
  end
end
