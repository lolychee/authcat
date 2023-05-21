# frozen_string_literal: true

class CreateUserIdentifiers < ActiveRecord::Migration[6.1]
  def change
    create_table :user_identifiers do |t|
      t.references :user, null: false, foreign_key: true, index: true

      t.string :name, null: false

      t.string :identifier, null: false
      t.string :identifier_type, null: false

      t.timestamps

      t.index %i[user_id name identifier], unique: true
      t.index %i[name identifier], unique: true
    end
  end
end
