# frozen_string_literal: true

class CreateIdentityProviders < ActiveRecord::Migration[6.1]
  def change
    create_table :identity_providers do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.string :token, null: false
      t.string :metadata, null: false

      t.string :type, null: false

      t.timestamps

      t.index %i[user_id type token], unique: true
    end
  end
end
